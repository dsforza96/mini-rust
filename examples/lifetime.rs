fn dummy <'a, 'b>(x: &'a int, y: &'b int) -> &'a int{
    let r = x + 15;
    x
}
    let w = 10;
    let res;
    {
        let q = 5;
        res = dummy (&w, &q);
    }
    println!(res);
