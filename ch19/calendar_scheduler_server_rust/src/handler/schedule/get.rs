use std::sync::Arc;

use axum::{
    Json,
    extract::{Query, State},
    http::StatusCode,
};
use serde::Deserialize;
use tracing::instrument;
use utoipa::IntoParams;
use uuid::Uuid;

use crate::{AppState, model::ScheduleModel};

/// GET /schedule?date={date} 핸들러
/// 일정을 날짜를 기준으로 가져온다.
#[utoipa::path(
    get,
    summary = "날짜를 기준으로 일정 가져오기",
    description = "날짜를 기준으로 일정을 가져옵니다.",
    path = "/schedule",
    params(Param),
    responses(
        (status = StatusCode::OK, description = "성공", body = [ScheduleModel], content_type = "application/json", example = json!(
            [ScheduleModel{
                id: Uuid::new_v4(),
                content: "프로그래밍 공부하기".to_string(),
                date: 20210102.to_string(),
                start_time: 12,
                end_time: 14
        }]),),
    )
)]
#[instrument(skip_all, name = "get_schedule", fields(date = %param.date))]
pub async fn get_schedule(
    State(state): State<Arc<AppState>>,
    Query(param): Query<Param>,
) -> Result<Json<Vec<ScheduleModel>>, StatusCode> {
    let schedules = state
        .schedule_storage
        .get_schedule_by_date(&param.date)
        .await
        .unwrap_or(Vec::new());

    Ok(Json(schedules))
}

/// GET /schedule?date={date}의 쿼리 파라미터
#[derive(Deserialize, IntoParams)]
pub struct Param {
    /// 일정을 필터링할 날짜
    pub date: String,
}

#[derive(utoipa::OpenApi)]
#[openapi(paths(get_schedule))]
pub struct ScheduleGetOpenApi;
