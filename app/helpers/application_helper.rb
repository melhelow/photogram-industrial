module ApplicationHelper
  def only_host_and_path(url)
    return "" if url.blank?

    uri = URI.parse(url)
    "#{uri.host}#{uri.path}"
  rescue URI::InvalidURIError
    url
  end
end
