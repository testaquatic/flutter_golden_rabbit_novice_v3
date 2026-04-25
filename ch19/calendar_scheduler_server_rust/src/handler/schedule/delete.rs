use std::sync::Arc;

use axum::{Json, extract::State, http::StatusCode};
use uuid::Uuid;

use crate::{AppState, handler::schedule::types::JsonUuid};

/// DELETE /schedule 핸들러
/// 조건과 일치하는 일정을 삭제한다.
#[utoipa::path(
    delete,
    summary = "일정 삭제",
    description = "일정을 삭제합니다.",
    path = "/schedule",
    request_body(
      content = JsonUuid, description = "삭제할 일정의 ID", content_type = "application/json", example = json!(JsonUuid{ id: Uuid::new_v4(),})
    ),
    responses(
      (status = StatusCode::OK, description = "성공", body = JsonUuid, content_type = "application/json", example = json!(JsonUuid{ id: Uuid::new_v4(),}))
    )
  )]
#[tracing::instrument(skip_all, name = "delete_schedule", fields(%id.id))]
pub async fn delete_schedule(
    State(state): State<Arc<AppState>>,
    Json(id): Json<JsonUuid>,
) -> Result<Json<JsonUuid>, StatusCode> {
    state
        .schedule_storage
        .remove_schedule(id.id)
        .await
        .map(|id| Json(JsonUuid { id }))
        .ok_or(StatusCode::BAD_REQUEST)
}

#[derive(utoipa::OpenApi)]
#[openapi(paths(delete_schedule))]
pub struct ScheduleDeleteOpenApi;
