module ApplicationHelper

  def comment_author_avatar(comment)
    if 'pixnet' == comment["author_login_type"]
      avatar = comment['user']['avatar']
    elsif 'openid' == comment['author_login_type']
      avatar = comment['openid_associate']['avatar']
    else
      avatar = 'http://s.pimg.tw/default/avatar/user/0/zoomcrop/50x50.jpg'
    end
    return image_tag(avatar, :widht => 50, :height => 50, :alt => comment['author'])
  end

  def comment_author_icon(comment)
    if 'pixnet' == comment["author_login_type"]
      icon = "//s.pixfs.net/f.pixnet.net/comment/images/openid-pixnet-icon.gif"
    elsif 'openid' == comment['author_login_type']
      icon = "//s.pixfs.net/f.pixnet.net/comment/images/openid-#{comment['openid_associate']['type']}-icon.gif"
    else
      icon = ''
    end

    if icon.empty?
      return ''
    else
      return image_tag(icon, :width => 16, :height => 16)
    end
  end

  def comment_author_link(comment)
    link = ''
    if 'pixnet' == comment["author_login_type"]
      link = "#{comment['user']['link']}/blog"
    else
      link = "javascript:;"
    end
    return link_to(comment["author"], link, :target => "_blank")
  end
end
