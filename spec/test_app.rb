require "sinatra"

get "/frank-says" do
  <<~HTML
    <p>Put this in your pipe & smoke it!</p>

    <div id="scoped">
      <p>Put this in your pipe & smoke it!</p>
    </div>

    <p>foo</p>

    <input type="text" name="filled" value="Existing Data">
    <input type="text" name="handle">
    <input type="checkbox" name="checker">
  HTML
end
