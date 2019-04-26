require 'rails_helper'

RSpec.describe 'book: index page', type: :feature do
  before(:each) do
    @author_1 = Author.create(name: "Larry Niven")
    @book_1 = Book.create(title: "Ringworld", pages: 430, year_published: 1970, thumbnail: "https://d2svrcwl6l7hz1.cloudfront.net/content/B00CNTUVLO/resources/0?mime=image/*")
    @book_2 = Book.create(title: "The Goliath Stone", pages: 320, year_published: 2013, thumbnail: "https://images-na.ssl-images-amazon.com/images/I/51l%2BUTphB1L.jpg")
    @ab_1 = AuthorBook.create(author_id: @author_1.id, book_id: @book_1.id)
    @ab_2 = AuthorBook.create(author_id: @author_1.id, book_id: @book_2.id)
    @review_1 = @book_1.reviews.create(user:"User 1", title:"Title", rating: 4, description:"Description")
    @review_2 = @book_1.reviews.create(user:"User 2", title:"Title", rating: 2, description:"Description")
    @review_3 = @book_2.reviews.create(user:"User 3", title:"Title", rating: 3, description:"Description")
    @review_4 = @book_2.reviews.create(user:"User 4", title:"Title", rating: 5, description:"Description")
    @review_4 = @book_1.reviews.create(user:"User 4", title:"Title", rating: 5, description:"Description")
  end

  describe 'when a user visits the book index' do
    it 'displays all books' do

      visit books_path

      expect(page).to have_content(@book_1.title)
      expect(page).to have_content("Pages: #{@book_1.pages}")
      expect(page).to have_content("Year Published: #{@book_1.year_published}")
      expect(page).to have_css("img[src*='#{@book_1.thumbnail}']")

      expect(page).to have_content(@book_2.title)
      expect(page).to have_content("Pages: #{@book_2.pages}")
      expect(page).to have_content("Year Published: #{@book_2.year_published}")
      expect(page).to have_css("img[src*='#{@book_2.thumbnail}']")
    end

    it 'displays the author name' do
      author_1 = Author.create(name: "Larry Niven")
      book_1 = Book.create(title: "Ringworld", pages: 430, year_published: 1970, thumbnail: "https://d2svrcwl6l7hz1.cloudfront.net/content/B00CNTUVLO/resources/0?mime=image/*")
      book_2 = Book.create(title: "The Goliath Stone", pages: 320, year_published: 2013, thumbnail: "https://images-na.ssl-images-amazon.com/images/I/51l%2BUTphB1L.jpg")
      ab_1 = AuthorBook.create(author_id: author_1.id, book_id: book_1.id)
      ab_2 = AuthorBook.create(author_id: author_1.id, book_id: book_2.id)

      visit books_path

      expect(page).to have_content(author_1.name)
    end

    it 'displays all authors if book has multiple' do
      author_1 = Author.create(name: "Larry Niven")
      author_2 = Author.create(name: "Jerry Pournelle")
      book_3 = Book.create(title: "Inferno", pages: 237, year_published: 1976,thumbnail: "https://upload.wikimedia.org/wikipedia/en/8/86/InfernoNovel.jpg")
      ab_3 = AuthorBook.create(author_id: author_1.id, book_id: book_3.id)
      ab_4 = AuthorBook.create(author_id: author_2.id, book_id: book_3.id)

      visit books_path

      expect(page).to have_content(author_1.name)
      expect(page).to have_content(author_2.name)
    end

  end

  describe 'for each book' do
    it 'shows average rating' do
      visit books_path
      within '#ringworld' do
        expect(page).to have_content("Average Rating: #{@book_1.average_rating.round(2)}")
      end

      within '#the-goliath-stone' do
        expect(page).to have_content("Average Rating: #{@book_2.average_rating.round(2)}")
      end
    end
  end

  describe 'for each author' do
    it 'displays the name as a link' do
      visit books_path
      within '#ringworld' do
        click_link(@author_1.name)
        expect(page).to have_current_path(author_path(@author_1))
      end

      visit books_path
      within '#the-goliath-stone' do
        click_link(@author_1.name)
        expect(page).to have_current_path(author_path(@author_1))
      end
    end
  end

  describe 'for each book' do
    it 'displays the title as a link' do
      visit books_path
      within '#worst_books' do
        click_link(@book_1.title)
        expect(page).to have_current_path(book_path(@book_1))
      end

      visit books_path
      within '#best_books' do
        click_link(@book_1.title)
        expect(page).to have_current_path(book_path(@book_1))
      end

      visit books_path
      within '#ringworld' do
        click_link(@book_1.title)
        expect(page).to have_current_path(book_path(@book_1))
      end


      visit books_path
      within '#worst_books' do
        click_link(@book_2.title)
        expect(page).to have_current_path(book_path(@book_2))
      end

      visit books_path
      within '#best_books' do
        click_link(@book_2.title)
        expect(page).to have_current_path(book_path(@book_2))
      end

      visit books_path
      within '#the-goliath-stone' do
        click_link(@book_2.title)
        expect(page).to have_current_path(book_path(@book_2))
      end
    end
  end

  describe 'for each user' do
    it 'displays the username as a link' do
      visit books_path
      click_link(@review_1.user)
      expect(page).to have_current_path(user_path(@review_1.user))

      visit books_path
      click_link(@review_2.user)
      expect(page).to have_current_path(user_path(@review_2.user))

      visit books_path

      click_link(@review_4.user)
      expect(page).to have_current_path(user_path(@review_4.user))
    end
  end
end
