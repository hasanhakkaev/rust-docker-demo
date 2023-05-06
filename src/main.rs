use chrono;

fn main() {
    println!("Hello, world!");
    // print time and date
    print!("The time is {}", chrono::Local::now().format("%H:%M:%S"));
    print!(
        " and the date is {}",
        chrono::Local::now().format("%Y-%m-%d")
    );
}
