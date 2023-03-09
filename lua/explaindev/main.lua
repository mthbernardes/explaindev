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
local aniseed_string, core, util, vim = autoload("explaindev.aniseed.string"), autoload("explaindev.aniseed.core"), autoload("explaindev.aniseed.nvim.util"), autoload("explaindev.aniseed.nvim")
do end (_2amodule_locals_2a)["aniseed-string"] = aniseed_string
_2amodule_locals_2a["core"] = core
_2amodule_locals_2a["util"] = util
_2amodule_locals_2a["vim"] = vim
local payload = "{\"language\":\"{{LANGUAGE}}\",\"mode\":\"rightClick\",\"source\":\"{{SOURCE}}\",\"explanationLevel\":\"advanced\",\"locale\":\"en\"}"
_2amodule_2a["payload"] = payload
local credentials = os.getenv("EXPLAINDEV_CREDS")
do end (_2amodule_2a)["credentials"] = credentials
local url = "https://api.explain.dev/api/explain"
_2amodule_2a["url"] = url
local function get_selected_text()
  local line_start = core.get(vim.fn.getpos("'<"), 3)
  local line_end = core.get(vim.fn.getpos("'>"), 3)
  local lines = vim.fn.getline(line_start, line_end)
  return aniseed_string.join(lines)
end
_2amodule_2a["get-selected-text"] = get_selected_text
local function buil_request_command(payload0)
  return core.str("! curl -s ", url, " -H 'Authorization: Basic ", credentials, "' -H 'Content-Type: application/json' --data-raw '", payload0, "' | jq -r '.answer'")
end
_2amodule_2a["buil-request-command"] = buil_request_command
local function clean_comand_output(output)
  return aniseed_string.trim(core.last(aniseed_string.split(output, "\13")))
end
_2amodule_2a["clean-comand-output"] = clean_comand_output
local function exec_request(request_payload)
  local curl_command = buil_request_command(request_payload)
  local raw_result
  local function _1_()
    return vim.command(curl_command)
  end
  raw_result = util["with-out-str"](_1_)
  return clean_comand_output(raw_result)
end
_2amodule_2a["exec-request"] = exec_request
local function init()
  local selected_text = get_selected_text()
  local request_payload = string.gsub(string.gsub(payload, "{{LANGUAGE}}", "plaintext"), "{{SOURCE}}", selected_text)
  return clean_comand_output(exec_request(request_payload))
end
_2amodule_2a["init"] = init
--[[ (init) ]]
return _2amodule_2a