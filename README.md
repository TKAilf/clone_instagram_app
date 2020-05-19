# README


自分が苦労をした点

1.開発環境の構築が難しい、Ruby6.0を使うことが出来たが あまり参考になるようなブログが無く、検索に苦労しました。
2.gitの知識があまりなかったため、検索を重ねながら解決していきました。
3.Web開発の流れを把握していなかった
4.form_forのコードを自作していて、思うように表示させたり情報を送ることが出来なかった。
5.ログイン機構周りの難しさ
6.form_withタグは他のformタグとは違い、デフォルトでremote: trueになっていると言うことに気づくのに時間がかかりました。
7.flashとflash.nowの違い
8.content_tagの仕組み

学んだ点

1.開発環境はRails5.2.4.2の方が参考文献なども多く、扱いやすかったため、Rails6での環境は断念しました。
2.gitにおけるプッシュ作業。ローカルリポジトリとリモートリポジトリとで競合を起こすことがあり、プッシュできないということを学びました。
3.Web開発は 企画→設計→開発→公開 の順に行うということを意識する
4.form_for , form_tag , form_withの使い方と、それぞれの特徴。また、f.labelなどでのplaceholderの使い方などを学びました。
5.device gem という、有名でとても便利なgemの存在を知りました。しかし、今回は勉強を兼ねているので使用は避けました。
6.form_withを使用する際の注意点。form_tag=>form_withのときはurl: ""で明示的にurlを指定する。form_for=>form_withのときはmodel: ""で明示的にモデルのインスタンス変数を指定する。
7.flashは次の次のアクションまで表示させる。flash.nowは次のアクションまで表示させる。という違いがあります。また、redirect_toは1回のアクションとなりますがrenderはアクションではないと判断されます。
8.content_tagヘルパーとは、railsでHTML表示をさせるための1つの手段。 content_tag(:div,"content",class: ["link","saiko"])=><div class="link saiko">content</div>

自慢したい・相談したい点
1.Rails Tutorialでは行っていなかったform_withでのフォーム実装