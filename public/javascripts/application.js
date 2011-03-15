// Common JavaScript code across your application goes here.

function getArticle (article_id, query) {
	if(!query) {
		window.location = "/news/" + article_id
	} else {
		window.location = "/news/" + article_id + "?query=" + query
	};

}

function getCategory (category_id, query) {
	if(!query) {
		window.location = "/news/?category_id=" + category_id
	} else {
		window.location = "/news?query=" + query
	};
}

function openTab (url) {
	gBrowser.selectedTab = gBrowser.addTab("http://www.google.com/");
}
