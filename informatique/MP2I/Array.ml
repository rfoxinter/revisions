let length arr =
    let l = ref 0 and count = ref true in
    while !count do
        try
            let _ = arr.(!l) in incr l
        with
            | Invalid_argument _ -> count := false
    done;
    !l;;