open Core
open Opium.Std


let ( >>>= ) = Lwt.( >>= )

let fetch_cached_wages cache =
  match !cache with
  | None ->
     begin
       Client.fetch_raw_wages_body >>>= function
       | None ->
          raise (Failure "could not get or parse wages")
       | Some values ->
          cache := Some values;
          Lwt.return values
     end
  | Some values ->
     Lwt.return values

let wages cache =
  get "/minimum_wage/" (fun _req ->
      fetch_cached_wages cache >>>= fun raw_wages ->
      let wages = List.map ~f:Parser.salary_line_to_yojson raw_wages in
      let headers = Cohttp.Header.(
          let headers = init () in
          add headers "content-type" "application/json"
                    ) in
      Lwt.return (Response.of_string_body
                    ~headers
                    (Yojson.Safe.to_string (`List wages))))

let run_server cache =
  App.empty
  |> wages cache
  |> App.run_command
