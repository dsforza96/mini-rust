fn main (){
    let x = 1;
    let y = &x;
    let z = &y;
    y = &z;
    println!("{}", y);    
}

