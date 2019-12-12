module.exports = (robot) ->
 questions = [
    {
        "id" : 0,
        "type" : "message",
        "title" : "チャットを終了します。"
    },
    {
        "id" : 1,
        "type" : "choice",
        "title" : "選択式サンプル1",
        "choices" : [
            "選択式サンプル2へ",
            "フォームサンプル1へ",
            "チャットを終える"
        ],
        "next_id" : [
            2,
            3,
            0
        ]
    },
    {
        "id" : 2,
        "type" : "choice",
        "title" : "選択式サンプル2",
        "choices" : [
            "選択式サンプル1へ",
            "フォームサンプル1へ",
            "チャットを終える"
        ],
        "next_id" : [
            1,
            3,
            0
        ]
    },
    {
        "id" : 3,
        "type" : "form",
        "title" : "フォームサンプル1",
        "next_id" : [
            0
        ]
    }
 ]

 id = 1
 accept = ""
 next = []

 title_generate = (question_data) ->
  text = ""
  title = question_data["title"]
  text = text + title + "\n"
  if question_data["type"] == "choice"
   number = 1
   for choice in question_data["choices"]
    text = text + number + ". " + choice + "\n"
    number = number + 1
  return text


 # hubot起動時の処理
 robot.respond /start/i, (msg) ->
  question_data = questions[id]
  text = title_generate(question_data)
  msg.send text
  accept = question_data["type"]
  if accept == "choice" || accept == "form"
   next = question_data["next_id"]
  else
   next = []

 # 選択式(type:choice)のときの処理
 robot.hear /([1-9])/i, (msg) ->
  if accept == "choice"
   id = next[parseInt(msg.match[1],10)-1]
   question_data = questions[id]
   text = title_generate(question_data)
   msg.send text
   accept = question_data["type"]
   if accept == "choice" || accept == "form"
    next = question_data["next_id"]
   else
    next = []

# フォーム式(type:form)のときの処理
 robot.hear /form .*/i, (msg) ->
  if accept == "form"
   id = next[0]
   question_data = questions[id]
   text = title_generate(question_data)
   msg.send text
   accept = question_data["type"]
   if accept == "choice" || accept == "form"
    next = question_data["next_id"]
   else
    next = []