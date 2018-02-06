fn dummy <'a>(x: &'a int, y: &'b int) -> &'a int{
    y
}
    let w = 10;
    let res;
    {
        let q = 5;
        res = dummy (&w, &q);
    }
    println!(res);
