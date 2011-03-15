require 'init'

map "/" do
	run WSJ::FrontPageApp
end

map "/news" do
	run WSJ::ArticlesApp
end