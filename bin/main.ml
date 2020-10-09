open Soldo
open Core
open Opium.Std


let get_opt = function
  | None -> raise (Invalid_argument "aaaaa")
  | Some x -> x
let mraw = Parser.parse_raw_salary_table Parser.teste
let raw = get_opt mraw
let salaries = Parser.parse_salaries raw

let servir =
  get "/minimum_wage/" (fun _req ->
      let salaries' = List.map ~f:Parser.salary_line_to_yojson salaries in
      let headers = Cohttp.Header.(
          let headers = init () in
          add headers "content-type" "application/json"
                    ) in
      Lwt.return (Response.of_string_body
                    ~headers
                    (Yojson.Safe.to_string (`List salaries'))))

(* let () =
 *   List.iter ~f:(fun l ->
 *       Parser.salary_line_to_yojson l
 *       |> Yojson.Safe.to_string
 *       |> print_endline
 *     ) salaries *)

let () =
  App.empty
  |> servir
  |> App.run_command
