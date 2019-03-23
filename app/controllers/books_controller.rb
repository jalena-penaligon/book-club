class BooksController < ApplicationController

  def index
    @books = if params[:sort]
      direction = params[:direction]
      case params[:sort]
      when 'reviews'
        Book.by_reviews(dir: direction)
      when 'pages'
        Book.by_pages(dir: direction)
      when 'rating'
        Book.by_average_ratings(dir: direction, limit: false)
      else
        Book.all
      end
    else
      Book.all
    end
    @worst_3 = Book.worst_3
    @best_3 = Book.best_3
    @top_reviewers = Review.top_reviewers
  end

  def show
    @book = Book.find(params[:id])
    @top_reviews = @book.top_reviews(3)
    @bottom_reviews = @book.bottom_reviews(3)
  end

  def new
    @book = Book.new
  end

  def create
    author_names = params[:authors].split(',')
    book = Book.new(book_params)
    if Book.already_exists?(book)
      redirect_to new_book_path
    else
    book.save
    assign_book_to_author(author_names, book)
    redirect_to book_path(book.id)
    end
  end

  def assign_book_to_author(author_names, book)
    author_names.each do |name|
      author = Author.find_or_create_by(name: name.strip)
      author.books << book
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :authors, :pages, :year_published, :thumbnail)
  end
end
