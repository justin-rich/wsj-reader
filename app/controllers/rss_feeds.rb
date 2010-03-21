class RssFeeds < Application
  # provides :xml, :yaml, :js

  def index
    @rss_feeds = RssFeed.all
    display @rss_feeds
  end

  def show(id)
    @rss_feed = RssFeed.get(id)
    raise NotFound unless @rss_feed
    display @rss_feed
  end

  def new
    only_provides :html
    @rss_feed = RssFeed.new
    display @rss_feed
  end

  def edit(id)
    only_provides :html
    @rss_feed = RssFeed.get(id)
    raise NotFound unless @rss_feed
    display @rss_feed
  end

  def create(rss_feed)
    @rss_feed = RssFeed.new(rss_feed)
    if @rss_feed.save
      redirect resource(@rss_feed), :message => {:notice => "RssFeed was successfully created"}
    else
      message[:error] = "RssFeed failed to be created"
      render :new
    end
  end

  def update(id, rss_feed)
    @rss_feed = RssFeed.get(id)
    raise NotFound unless @rss_feed
    if @rss_feed.update(rss_feed)
       redirect resource(@rss_feed)
    else
      display @rss_feed, :edit
    end
  end

  def destroy(id)
    @rss_feed = RssFeed.get(id)
    raise NotFound unless @rss_feed
    if @rss_feed.destroy
      redirect resource(:rss_feeds)
    else
      raise InternalServerError
    end
  end

end # RssFeeds
