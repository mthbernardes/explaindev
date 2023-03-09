(module explaindev.main
  {autoload {vim aniseed.nvim
             util aniseed.nvim.util
             aniseed-string aniseed.string
             core aniseed.core}})

(def payload "{\"language\":\"{{LANGUAGE}}\",\"mode\":\"rightClick\",\"source\":\"{{SOURCE}}\",\"explanationLevel\":\"advanced\",\"locale\":\"en\"}")
(def credentials (os.getenv "EXPLAINDEV_CREDS"))
(def url "https://api.explain.dev/api/explain")

(defn get-selected-text [] 
  (let [line_start (core.get (vim.fn.getpos "'<") 3)
        line_end (core.get  (vim.fn.getpos "'>") 3)
        lines (vim.fn.getline line_start line_end)]
    (aniseed-string.join lines)))

(defn buil-request-command [payload] 
  (core.str "! curl -s " url " -H 'Authorization: Basic " credentials "' -H 'Content-Type: application/json' --data-raw '" payload "' | jq -r '.answer'"))

(defn clean-comand-output [output] 
  (-> output (aniseed-string.split "\r") core.last aniseed-string.trim))

(defn exec-request [request-payload] 
  (let [curl-command (buil-request-command request-payload)
        raw-result (util.with-out-str #(vim.command curl-command))]
    (clean-comand-output raw-result)))

(defn init []
  (let [selected-text (get-selected-text)
        request-payload (-> payload 
                            (string.gsub "{{LANGUAGE}}" "plaintext")
                            (string.gsub "{{SOURCE}}" selected-text))]
    (-> request-payload (exec-request) (clean-comand-output))))

(comment
  (init))


