mod database;
mod handler;
mod model;

use std::{collections::HashMap, sync::Arc};

use axum::{
    Router,
    extract::Request,
    middleware::{self, Next},
    response::Response,
    routing::get,
};
use tokio::sync::Mutex;
use tower_http::trace::TraceLayer;
use tracing::info;
use tracing_subscriber::fmt::format::FmtSpan;
use utoipa::{
    OpenApi,
    openapi::{Info, OpenApiBuilder},
};
use utoipa_swagger_ui::SwaggerUi;

use crate::{
    database::ScheduleStorage,
    handler::schedule::{
        ScheduleDeleteOpenApi, ScheduleGetOpenApi, SchedulePostOpenApi, delete_schedule,
        get_schedule, post_schedule,
    },
};

pub async fn run_app() -> Result<(), std::io::Error> {
    // tracing를 활성화한다.
    tracing_subscriber::FmtSubscriber::builder()
        .with_span_events(FmtSpan::NEW | FmtSpan::CLOSE)
        .with_env_filter(
            tracing_subscriber::EnvFilter::try_from_default_env()
                .unwrap_or("debug,tower_http=info".into()),
        )
        .pretty()
        .init();

    // axum의 상태를 생성한다.
    let app_state = Arc::new(AppState {
        schedule_storage: ScheduleStorage {
            schedules: Mutex::new(HashMap::new()),
            date_index: Mutex::new(HashMap::new()),
        },
    });

    // swagger를 설정한다.
    let mut openapi = OpenApiBuilder::default()
        .info(
            Info::builder()
                .title("러스트로 작성한 Code Factory 샘플 API")
                .version("1.0")
                .description(Some("골든래빗 스케쥴러 프로젝트 연습용")),
        )
        .build();
    openapi.merge(ScheduleGetOpenApi::openapi());
    openapi.merge(SchedulePostOpenApi::openapi());
    openapi.merge(ScheduleDeleteOpenApi::openapi());

    // 라우터를 생성한다.
    let app = Router::new()
        .route(
            "/schedule",
            get(get_schedule)
                .post(post_schedule)
                .delete(delete_schedule)
                .layer(middleware::from_fn(delay_middleware)),
        )
        .with_state(app_state)
        .merge(SwaggerUi::new("/swagger").url("/swagger.json", openapi))
        .layer(TraceLayer::new_for_http().make_span_with(|req: &Request| {
            let addr = req.uri().to_string();
            tracing::info_span!("reqeust", addr = addr)
        }));

    // TcpListener를 생성한다.
    let listener = tokio::net::TcpListener::bind("0.0.0.0:8000").await?;
    let addr = listener.local_addr()?;
    info!("Listening on {}", addr);

    info!("Start the server");
    info!("{}/schedule", addr);
    info!("{}/swagger", addr);
    // 서버를 실행한다.
    axum::serve(listener, app).await
}

async fn delay_middleware(request: Request, next: Next) -> Response {
    tokio::time::sleep(tokio::time::Duration::from_millis(500)).await;

    let response = next.run(request).await;

    tokio::time::sleep(tokio::time::Duration::from_millis(500)).await;

    response
}

struct AppState {
    schedule_storage: ScheduleStorage,
}
