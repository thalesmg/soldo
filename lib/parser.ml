open Core
open Soup

type raw_table = {
    headers : string list;
    lines : string list list
  }

type date = {
    day: int;
    month: int;
    year: int
  } [@@deriving sexp, yojson]

type salary_line = {
    reference_date: date;
    value: int
  } [@@deriving sexp, yojson]

let teste = read_file "/tmp/bah.htm" |> parse

let parse_soup = parse

let parse_date str =
  try
    Scanf.sscanf str "%02d.%02d.%04d"
      (fun day month year -> Some {day; month; year})
  with
  | Scanf.Scan_failure _ -> None

let parse_money string =
  let open Option.Monad_infix in
  let open Re in
  let normalized =
    string
    |> replace_string (compile @@ Perl.re "^R\\$ ") ~by:""
    |> replace_string (compile @@ Perl.re "\\.") ~by:""
    |> replace_string (compile @@ Perl.re ",") ~by:"." in
  let of_string_opt fl =
    try
      Some (Float.of_string fl)
    with
    | Invalid_argument _ -> None in
  Float.(
    of_string_opt normalized >>= fun fl ->
    Some (to_int @@ fl *. 100.)
  )

let parse_salary_line = function
  | date :: salary :: _ ->
     let open Option.Monad_infix in
     (parse_date date) >>= fun reference_date ->
     (parse_money salary) >>= fun value ->
     Some { reference_date; value }
  | _ ->
     None

let parse_raw_salary_table soup =
  let table = soup $ "table" $$ "tr" in
  let rows = to_list table
             |> List.map ~f:(fun tr ->
                    tr $$ "td"
                    |> to_list
                    |> List.map ~f:(fun tds ->
                           trimmed_texts tds
                           |> String.concat ~sep:" "
                  )) in
  match rows with
  | [] -> None
  | headers :: lines -> Some { headers; lines }

let parse_salaries = function
    { lines; _ } ->
    List.filter_map ~f:parse_salary_line lines
