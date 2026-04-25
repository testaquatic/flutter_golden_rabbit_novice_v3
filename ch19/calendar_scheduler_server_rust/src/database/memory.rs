use std::collections::HashMap;

use tokio::sync::Mutex;
use uuid::Uuid;

use crate::model::ScheduleModel;

/// DB를 모사한다.
pub struct ScheduleStorage {
    /// UUID가 키이다.
    pub schedules: Mutex<HashMap<Uuid, ScheduleModel>>,
    /// 날짜가 키이다.(YYMMDD 형식)
    pub date_index: Mutex<HashMap<String, Vec<Uuid>>>,
}

impl ScheduleStorage {
    /// 날짜를 기준으로 일정을 가져온다.
    pub async fn get_schedule_by_date(&self, date: &str) -> Option<Vec<ScheduleModel>> {
        let date_index_lock = self.date_index.lock().await;
        let ids = date_index_lock.get(date)?;
        let schedules_lock = self.schedules.lock().await;

        let schedules = ids
            .iter()
            .map(|id| schedules_lock.get(id).expect("Must be Some").clone())
            .collect();

        Some(schedules)
    }

    /// 일정을 추가한다.
    pub async fn add_schedule(&self, mut schedule: ScheduleModel) -> Uuid {
        let uuid = Uuid::new_v4();
        schedule.id = uuid;

        self.date_index
            .lock()
            .await
            .entry(schedule.date.clone())
            .or_default()
            .push(uuid);
        self.schedules.lock().await.insert(uuid, schedule);

        uuid
    }

    /// 일정을 삭제한다.
    pub async fn remove_schedule(&self, id: Uuid) -> Option<Uuid> {
        let schedule = self.schedules.lock().await.remove(&id)?;
        self.date_index
            .lock()
            .await
            .entry(schedule.date)
            .and_modify(|schedules| {
                schedules.retain(|item| *item != id);
            });

        Some(id)
    }
}
