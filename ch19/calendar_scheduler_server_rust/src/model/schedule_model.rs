use serde::Serialize;
use utoipa::ToSchema;
use uuid::Uuid;

#[derive(Serialize, ToSchema, Clone)]
#[serde(rename_all = "camelCase")]
pub struct ScheduleModel {
    /// 아이디
    pub id: Uuid,
    /// 일정 내용
    pub content: String,
    /// 일정 날짜 (YYMMDD)
    pub date: String,
    /// 시작 시간
    pub start_time: u8,
    /// 마감 시간
    pub end_time: u8,
}
