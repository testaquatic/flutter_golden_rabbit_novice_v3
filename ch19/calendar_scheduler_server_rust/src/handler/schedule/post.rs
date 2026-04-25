use std::sync::Arc;

use axum::{Json, extract::State, http::StatusCode};
use serde::Deserialize;
use utoipa::ToSchema;
use uuid::Uuid;

use crate::{AppState, handler::schedule::types::JsonUuid, model::ScheduleModel};

/// POST /schedule 핸들러
/// 일정을 생성한다.
#[utoipa::path(
  post, 
  summary = "새로운 일정 생성",
  description = "새로운 일정을 생성합니다.",
  path = "/schedule",
  request_body(
    content = PostScheduleRequestBody, description = "일정 정보", content_type = "application/json", example = json!({ "date": 202110102, "content": "프로그래밍 공부하기", "startTime": 12, "endTime": 14})
  ),
  responses(
    (status = StatusCode::CREATED, description = "새로 생성한 일정의 ID값을 반환합니다.", body = JsonUuid, content_type = "application/json", example = json!(JsonUuid{ id: Uuid::new_v4(),}))
  )
)]
#[tracing::instrument(skip_all, name = "post_schedule", fields(date = %body.date, content = %body.content, start_time = %body.start_time, end_time = %body.end_time))]
pub async fn post_schedule(
    State(state): State<Arc<AppState>>,
    Json(body): Json<PostScheduleRequestBody>,
) -> Result<Json<JsonUuid>, StatusCode> {
    let schedule = ScheduleModel {
        id: Uuid::default(),
        content: body.content,
        date: body.date,
        start_time: body.start_time,
        end_time: body.end_time,
    };

    let uuid = state.schedule_storage.add_schedule(schedule).await;

    Ok(Json(JsonUuid { id: uuid }))
}


#[derive(Deserialize, ToSchema)]
#[serde(rename_all = "camelCase")]
pub struct PostScheduleRequestBody {
    content: String,
    date: String,
    start_time: u8,
    end_time: u8,
}

#[derive(utoipa::OpenApi)]
#[openapi(paths(post_schedule))]
pub struct SchedulePostOpenApi;
