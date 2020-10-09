open Core
open Cohttp_lwt_unix
open Lwt

let source_uri = Uri.of_string "http://www.guiatrabalhista.com.br/guia/salario_minimo.htm"

let fetch_raw_wages_body =
  Client.get source_uri >>= fun (_resp, body) ->
  body |> Cohttp_lwt.Body.to_string >|= fun body ->
  let open Option.Monad_infix in
  body
  |> Parser.parse_soup
  |> Parser.parse_raw_salary_table
  >>= fun raw -> Parser.parse_salaries raw |> Option.some

let fetch_raw_wages () = Lwt_main.run (fetch_raw_wages_body)
