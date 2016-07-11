module ProgressHelper

  def progress_for(resource, user)
    content_tag :div, class: 'card-progress' do
      content_tag( :div, { class: 'progress', data: { progress: "#{ resource.progress(user) }" } } ) do
        "#{ number_to_percentage(resource.progress(user), precision: 0) }"
      end
    end
  end

end
