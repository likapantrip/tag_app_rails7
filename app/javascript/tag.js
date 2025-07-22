document.addEventListener("turbo:load", () => {
  // タグの入力フォームのidを指定し、タグの要素を取得
  const tagNameInput = document.querySelector("#post_form_tag_name");
  
  if (tagNameInput){
    // inputElementを定義
    const inputElement = document.getElementById("post_form_tag_name");
    // フォームに文字が入力されたときに発火する関数を定義
    inputElement.addEventListener("input", () => {
      // フォームに入力されている文字列を変数keywordに代入
      const keyword = document.getElementById("post_form_tag_name").value;
      // 非同期通信に必要なXMLHttpRequestオブジェクトを生成し、変数XHRに代入
      const XHR = new XMLHttpRequest();
      // searchアクションへのリクエストを定義
      XHR.open("GET", `/posts/search/?keyword=${keyword}`, true);
      // コントローラーから返却されるデータの形式は、jsonを指定
      XHR.responseType = "json";
      // リクエストを送信
      XHR.send();
      // 非同期通信が成功したときに呼び出される関数を設定
      XHR.onload = () => {
        // HTMLを作成し、タグを表示する
        const searchResult = document.getElementById("search-result"); // idを取得
        // 直前の検索結果を消す
        searchResult.innerHTML = "";

        // レスポンスにデータが存在する場合のみ、タグを表示させる
        if (XHR.response) {
          // サーバーサイドの処理が成功したときにレスポンスとして返ってくるデータを受け取る
          const tagName = XHR.response.keyword;
          // 検索結果があるだけ繰り返す
          tagName.forEach((tag) => {
            const childElement = document.createElement("div"); // タグを表示させるための要素を生成
            childElement.setAttribute("class", "child"); // 生成した要素にclassを指定
            childElement.setAttribute("id", tag.id); // 生成した要素にidを指定
            childElement.innerHTML = tag.tag_name; // 生成した要素の内容に検索結果のタグ名を指定
            searchResult.appendChild(childElement); // 生成したchildElement要素をsearchResult要素に挿入

            // クリックしたタグ名がフォームに入力される
            const clickElement = document.getElementById(tag.id);
            // clickイベントを指定
            clickElement.addEventListener("click", () => {
              // フォームにタグ名を入力
              document.getElementById("post_form_tag_name").value = clickElement.textContent;
              // タグを表示している要素を削除
              clickElement.remove();
            });
          });
        }
      };
    });
  };
});