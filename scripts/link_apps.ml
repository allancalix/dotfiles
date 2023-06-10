open Core.Option

let nix_home_dir () =
  Core.Sys.(getenv "HOME") >>= fun home ->
  return (home ^ "/.nix-profile/Applications")

let target_path app =
  Core.Sys.(getenv "HOME") >>= fun home ->
  return (home ^ "/Applications/" ^ app)
let link_app app =
  target_path app >>= fun target ->
  nix_home_dir () >>= fun nix_home ->
  let source = nix_home ^ "/" ^ app in
  match Sys_unix.file_exists target with
  | `Yes -> return @@ print_endline ("File " ^ target ^ " already exists")
  | _ ->
    Printf.printf "App %s not found, creating link at %s.\n" app target;
    return @@ Unix.symlink source target

let () =
  match nix_home_dir () with
  | Some nix_home -> let apps = Sys_unix.ls_dir nix_home in
    apps |> List.iter (fun app ->
      let _ = link_app app in
      ())
  | None -> ()
