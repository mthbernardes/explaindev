(module explaindev.main
  {autoload {nvim aniseed.nvim
             util aniseed.nvim.util
             aniseed-string aniseed.string
             core aniseed.core}})

(def credentials (os.getenv "EXPLAINDEV_CREDS"))

(def url "https://api.explain.dev/api/explain")

(def payload {:language nil
              :mode "rightClick"
              :source nil
              :explanationLevel "advanced"
              :locale "en"})

(defn ->tojson [payload]
  (core.spit "/tmp/payload" (core.str payload))
  (->
    (nvim.fn.systemlist "cat /tmp/payload | jet --to json")
    (aniseed-string.join)))

(defn get-selected-text [] 
  (let [line_start (core.get (nvim.fn.getpos "'<") 2)
        line_end (core.get  (nvim.fn.getpos "'>") 2)
        lines (nvim.fn.getline line_start line_end)]
    (aniseed-string.join lines)))

(defn buil-request-command [payload] 
  (core.str "curl -s " url " -H 'Authorization: Basic " credentials "' -H 'Content-Type: application/json' -d '" payload "' | jq -r '.answer'"))

(defn exec-request [request-payload] 
  (let [curl-command (buil-request-command request-payload)
        raw-result (nvim.fn.systemlist curl-command)]
    raw-result))

(defn open-buffer [text]
  (let [buff (nvim.create_buf false true)
        width (nvim.get_option "columns")
        win_width (math.ceil (* width 0.8))
        height (nvim.get_option "lines")
        win_height (math.ceil (- (* height  0.8) 4))
        row (math.ceil (- (/ (- height win_height) 2) 1))
        col (math.ceil (/ (- width win_width) 2))
        opts {:style "minimal"
              :relative "editor"
              :width win_width
              :height win_height
              :row row
              :col col}]
    (nvim.buf_set_option buff "bufhidden" "wipe")
    (nvim.buf_set_lines buff 0 -1 false text)
    (nvim.open_win buff true opts)))

(defn explain []
  (let [selected-text (get-selected-text)
        request-payload (core.assoc payload :language "plaintext" :source selected-text)]
    selected-text
    ;(-> request-payload
    ;    (->tojson)
    ;    (exec-request)
    ;    (open-buffer))
    ))

(defn init [])

(explain)
