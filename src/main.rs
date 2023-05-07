use chrono;

fn main() {
    println!("Hello, world!");
    // print time and date
    print!("The time is {}", chrono::Local::now().format("%H:%M:%S"));
    print!(
        " and the date is {}",
        chrono::Local::now().format("%Y-%m-%d")
    );
    println!("\nBye, world!");

    // Print random quote
    println!("Random quote 1");
    println!("Random quote 2");
    println!("Random quote 3");
    println!("Random quote 4");

}
