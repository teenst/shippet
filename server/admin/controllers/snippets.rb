Admin.controllers :snippets do

  get :index do
    @snippets = Snippet.all
    render 'snippets/index'
  end

  get :new do
    @snippet = Snippet.new
    render 'snippets/new'
  end

  post :create do
    @snippet = Snippet.new(params[:snippet])
    if @snippet.save
      flash[:notice] = 'Snippet was successfully created.'
      redirect url(:snippets, :edit, :id => @snippet.id)
    else
      render 'snippets/new'
    end
  end

  get :edit, :with => :id do
    @snippet = Snippet.find(params[:id])
    render 'snippets/edit'
  end

  put :update, :with => :id do
    @snippet = Snippet.find(params[:id])
    if @snippet.update_attributes(params[:snippet])
      flash[:notice] = 'Snippet was successfully updated.'
      redirect url(:snippets, :edit, :id => @snippet.id)
    else
      render 'snippets/edit'
    end
  end

  delete :destroy, :with => :id do
    snippet = Snippet.find(params[:id])
    if snippet.destroy
      flash[:notice] = 'Snippet was successfully destroyed.'
    else
      flash[:error] = 'Unable to destroy Snippet!'
    end
    redirect url(:snippets, :index)
  end
end
