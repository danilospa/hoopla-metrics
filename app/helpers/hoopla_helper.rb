module HooplaHelper
  def merge_id(entity)
    entity.merge(id: extract_id_from_url(entity[:href]))
  end

  def extract_id_from_url(url)
    url.split('/').last
  end
end
