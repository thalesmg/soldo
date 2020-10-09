open Core
open Opium.Std


let () =
  let cache = ref None in
  App.empty
  |> Soldo__Server.wages cache
  |> App.run_command
