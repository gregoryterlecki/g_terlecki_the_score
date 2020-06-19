defmodule GTerleckiTheScoreWeb.ExportController do
    use GTerleckiTheScoreWeb, :controller
    alias GTerleckiTheScore.{Repo, Export}    

    # Take note of the fact you couldn't reuse the scrivener implementaton here 
    def index(conn, params) do
        Export.handle_export(conn, params)
    end
end