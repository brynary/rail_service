class <%= class_name %>Api < RailService::API

  namespace "<%= file_name %>" do
    get ":id" do
      <%= class_name %>.find(params[:id])
    end
  end

end
