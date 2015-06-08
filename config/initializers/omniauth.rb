Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '496139213872435', 'c63092f202297ddc1ed97470bbeae10a'
end