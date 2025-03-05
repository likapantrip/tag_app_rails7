function tag (){
  // 入力フォームのid(post_form_tag_name)を指定し、タグの要素を取得
  const tagNameInput = document.querySelector("#post_form_tag_name");

  // 入力フォームのid(post_form_tag_name)が存在する場合、下記処理を行う
    if (tagNameInput){
      // フォームに文字が入力されたときに発火する関数を定義
      const inputElement = document.getElementById("post_form_tag_name");

      inputElement.addEventListener("input", () => {
        // フォームに入力されている文字列を変数 keywordに代入
        const keyword = document.getElementById("post_form_tag_name").value;

        // XMLHttpRequestオブジェクトを用いてインスタンスを生成し、変数XHRに代入
        const XHR = new XMLHttpRequest();

        // searchアクションへリクエストを送付
        XHR.open("GET", `/posts/search/?keyword=${keyword}`, true);

        // コントローラーから返却されるデータの形式は、jsonを指定
        XHR.responseType = "json";

        // リクエストを送信
        XHR.send();

        // コントローラから返ってきた情報を元に、タグを表示させる実装
        XHR.onload = () => {
          // タグを表示させる場所を取得
          const searchResult = document.getElementById("search-result");

          // innerHTMLプロパティに対して、空の文字列を指定することで、表示されているタグを消す
          // タグの重複表示を避ける
          searchResult.innerHTML = "";

          // レスポンスにデータが存在する場合のみ、タグを表示させる
          if (XHR.response) {
            // レスポンスとして返ってくるデータを受け取る
            const tagName = XHR.response.keyword;

            // 検索結果があるだけ繰り返す
            tagName.forEach((tag) => {
              // タグ名を格納するための要素を作成する
              const childElement = document.createElement("div");
              childElement.setAttribute("class", "child");
              childElement.setAttribute("id", tag.id);
              childElement.innerHTML = tag.tag_name;

              // 作成した要素を表示させる
              searchResult.appendChild(childElement);

              // クリックされたら、フォームにタグ名を入力して、タグを表示している要素を削除する
              const clickElement = document.getElementById(tag.id);
              clickElement.addEventListener("click", () => {
                document.getElementById("post_form_tag_name").value = clickElement.textContent;
                clickElement.remove();
              });
            });
          }
        };
      });
    };
};

window.addEventListener('turbo:load', tag);
window.addEventListener("turbo:render", tag);