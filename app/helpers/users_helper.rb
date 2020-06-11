module UsersHelper
  
  #引数(user)で与えられたユーザーにGravatar画像を返す
  def gravatar_for(user, options = { size: 80 })
    if user.email.present?
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      size = options[:size]
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
      image_tag(gravatar_url, alt: user.name, class: "gravatar img-thumbnail")
    else
      image_tag(user.image_url, alt: user.name, class: "gravatar img-thumbnail")
    end
  end
  
end