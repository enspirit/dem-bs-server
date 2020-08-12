open Opium.Std;

let _ = App.empty

|> get("/hello/:name", req => {
  let person = param(req, "name");
  Lwt.return(Response.of_string_body(person));
})

|> post("/pdf", _req => {
  Lwt.return(Response.of_string_body("NOT IMPLEMENTED YET"));
})

|> App.run_command
;
