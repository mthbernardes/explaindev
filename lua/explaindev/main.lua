local _2afile_2a = "fnl/explaindev/main.fnl"
local _2amodule_name_2a = "explaindev.main"
local _2amodule_2a
do
  package.loaded[_2amodule_name_2a] = {}
  _2amodule_2a = package.loaded[_2amodule_name_2a]
end
local _2amodule_locals_2a
do
  _2amodule_2a["aniseed/locals"] = {}
  _2amodule_locals_2a = (_2amodule_2a)["aniseed/locals"]
end
local autoload = (require("explaindev.aniseed.autoload")).autoload
local aniseed_string, core, nvim, util = autoload("explaindev.aniseed.string"), autoload("explaindev.aniseed.core"), autoload("explaindev.aniseed.nvim"), autoload("explaindev.aniseed.nvim.util")
do end (_2amodule_locals_2a)["aniseed-string"] = aniseed_string
_2amodule_locals_2a["core"] = core
_2amodule_locals_2a["nvim"] = nvim
_2amodule_locals_2a["util"] = util
local credentials = os.getenv("EXPLAINDEV_CREDS")
do end (_2amodule_2a)["credentials"] = credentials
local url = "https://api.explain.dev/api/explain"
_2amodule_2a["url"] = url
local payload = {language = nil, mode = "rightClick", source = nil, explanationLevel = "advanced", locale = "en"}
_2amodule_2a["payload"] = payload
local function __3etojson(payload0)
  core.spit("/tmp/payload", core.str(payload0))
  return aniseed_string.join(nvim.fn.systemlist("cat /tmp/payload | jet --to json"))
end
_2amodule_2a["->tojson"] = __3etojson
local function get_selected_text()
  local line_start = core.get(nvim.fn.getpos("'<"), 2)
  local line_end = core.get(nvim.fn.getpos("'>"), 2)
  local lines = nvim.fn.getline(line_start, line_end)
  return aniseed_string.join(lines)
end
_2amodule_2a["get-selected-text"] = get_selected_text
local function buil_request_command(payload0)
  return core.str("curl -s ", url, " -H 'Authorization: Basic ", credentials, "' -H 'Content-Type: application/json' -d '", payload0, "' | jq -r '.answer'")
end
_2amodule_2a["buil-request-command"] = buil_request_command
local function exec_request(request_payload)
  local curl_command = buil_request_command(request_payload)
  local raw_result = nvim.fn.systemlist(curl_command)
  return raw_result
end
_2amodule_2a["exec-request"] = exec_request
local function open_buffer(text)
  local buff = nvim.create_buf(false, true)
  local width = nvim.get_option("columns")
  local win_width = math.ceil((width * 0.8))
  local height = nvim.get_option("lines")
  local win_height = math.ceil(((height * 0.8) - 4))
  local row = math.ceil((((height - win_height) / 2) - 1))
  local col = math.ceil(((width - win_width) / 2))
  local opts = {style = "minimal", relative = "editor", width = win_width, height = win_height, row = row, col = col}
  nvim.buf_set_option(buff, "bufhidden", "wipe")
  nvim.buf_set_lines(buff, 0, -1, false, text)
  return nvim.open_win(buff, true, opts)
end
_2amodule_2a["open-buffer"] = open_buffer
local function explain()
  local selected_text = get_selected_text()
  local request_payload = core.assoc(payload, "language", "plaintext", "source", selected_text)
  return selected_text
end
_2amodule_2a["explain"] = explain
local function init()
end
_2amodule_2a["init"] = init
explain()
return _2amodule_2a