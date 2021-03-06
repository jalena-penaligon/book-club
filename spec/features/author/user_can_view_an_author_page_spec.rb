require 'rails_helper'

RSpec.describe 'author: show page', type: :feature do
  before(:each) do
    @author_1 = Author.create(name: "Larry Niven")
    @author_2 = Author.create(name: "Jerry Pournelle")
    @book_1 = Book.create(title: "Ringworld", pages: 430, year_published: 1970, thumbnail: "https://d2svrcwl6l7hz1.cloudfront.net/content/B00CNTUVLO/resources/0?mime=image/*")
    @book_2 = Book.create(title: "The Goliath Stone", pages: 320, year_published: 2013, thumbnail: "https://images-na.ssl-images-amazon.com/images/I/51l%2BUTphB1L.jpg")
    @book_3 = Book.create(title: "Inferno", pages: 237, year_published: 1976,thumbnail: "https://upload.wikimedia.org/wikipedia/en/8/86/InfernoNovel.jpg")
    @author_1.books << @book_1
    @author_1.books << @book_2
    @author_1.books << @book_3
    @author_2.books << @book_3
    @review_1 = @book_1.reviews.create(user: "Debbie", title: "Hated It", rating: 1, description: "Boo.")
    @review_2 = @book_1.reviews.create(user: "Joe", title: "Loved It", rating: 5, description: "Exciting!")
  end

  it 'displays single author page' do
    visit author_path(@author_1)

    expect(page).to have_content(@author_1.name)

    within '#ringworld' do
      expect(page).to have_content(@book_1.title)
      expect(page).to have_content("Pages: #{@book_1.pages}")
      expect(page).to have_content("Year Published: #{@book_1.year_published}")
      expect(page).to have_css("img[src*='#{@book_1.thumbnail}']")
    end

    within '#the-goliath-stone' do
      expect(page).to have_content(@book_2.title)
      expect(page).to have_content("Pages: #{@book_2.pages}")
      expect(page).to have_content("Year Published: #{@book_2.year_published}" )
      expect(page).to have_css("img[src*='#{@book_2.thumbnail}']")
    end

    within '#inferno' do
      expect(page).to have_content(@book_3.title)
      expect(page).to have_content("Co-Author: #{@author_2.name}")
      expect(page).to have_content("Pages: #{@book_3.pages}")
      expect(page).to have_content("Year Published: #{@book_3.year_published}")
      expect(page).to have_css("img[src*='#{@book_3.thumbnail}']")
    end
  end

  it 'will not display the current author under co-authors' do
    visit author_path(@author_1)

    within '#inferno' do
      expect(page).to have_content("Co-Author: #{@author_2.name}")
      expect(page).to_not have_content(@author_1.name)
    end
  end

  it 'will show the top review' do
    visit author_path(@author_1)

    within '#ringworld' do
      expect(page).to have_content(@review_2.title)
      expect(page).to have_content(@review_2.description)
      expect(page).to have_content("Rating: #{@review_2.rating}")
      expect(page).to have_content(@review_2.user)

      expect(page).to_not have_content(@review_1.title)
      expect(page).to_not have_content(@review_1.description)
      expect(page).to_not have_content("Rating: #{@review_1.rating}")
      expect(page).to_not have_content(@review_1.user)
    end
  end

  it 'has a link to delete an author' do
    visit author_path(@author_1)
    click_link("- Delete This Author")

    expect(current_path).to eq(books_path)

    expect(page).to_not have_content(@author_1.name)
    expect(page).to_not have_content(@book_1.title)
    expect(page).to_not have_content(@book_2.title)
    expect(page).to_not have_content(@book_3.title)

    visit author_path(@author_2)
    expect(page).to have_content(@author_2.name)
  end

  it 'shows user names as a link' do
    visit author_path(@author_1)
    click_link(@review_2.user)
    expect(page).to have_current_path(user_path(@review_2.user))
  end

  it 'shows book titles as a link' do
    visit author_path(@author_1)
    click_link(@book_1.title)

    visit author_path(@author_1)
    click_link(@book_2.title)

    visit author_path(@author_1)
    click_link(@book_2.title)

    visit author_path(@author_2)
    click_link(@book_3.title)
  end
end
