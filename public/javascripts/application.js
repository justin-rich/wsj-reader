// Common JavaScript code across your application goes here.

function getArticle (article_id, query) {
	if(!query) {
		window.location = "/articles/" + article_id
	} else {
		window.location = "/articles/" + article_id + "?query=" + query
	};

}

function getCategory (category_id, query) {
	if(!query) {
		window.location = "/categories/" + category_id + "/articles/"
	} else {
		window.location = "/articles?query=" + query
	};
}

function openTab (url) {
	gBrowser.selectedTab = gBrowser.addTab("http://www.google.com/");
}
