use calendar_scheduler_server_rust::run_app;

#[tokio::main]
async fn main() {

    run_app().await.expect("오류가 발생했습니다.");
}
