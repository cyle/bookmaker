$KCODE="U"
# the KCODE sets ruby to use UTF-8 correctly

require "rubygems"
require "prawn"
require "nokogiri"
require "open-uri"

# where should the page numbering begin?
pagecount_start = 7

# what site should we base the book on?
doc = Nokogiri::HTML(open('http://localhost/yourbook.html'))

# new document is 6" (432) x 9" (648) with a 1" (72) margin and a 0.125" bleed (so 6.25" (450) x 9.25" (666) with 1.125" (81) margin)
pdf = Prawn::Document.new :margin => [81], :page_size => [450, 666], :info => { :Title => "Awesome Book Title", :Author => "Your Name Here" }
pdf.font_size 10

pdf.font_families.update("PT Serif" => {
  :normal => "PT_Serif-Web-Regular.ttf",
  :bold => "PT_Serif-Web-Bold.ttf",
  :italic => "PT_Serif-Web-Italic.ttf",
  :bold_italic => "PT_Serif-Web-BoldItalic.ttf"
})

pdf.font_families.update("Open Sans" => {
  :normal => "OpenSans-ExtraBold.ttf"
})

pdf.font_families.update("Open Sans Condensed" => {
  :normal => "OpenSans-CondBold.ttf"
})

pdf.font "PT Serif"

doc.css('div#book div.major-section').each do |majorsection|
  
  puts "processing major section ===="
  
  # section.class = Nokogiri::XML::Element
  # every major section has an h1 which is the major section title
  # every minor section has an h2 which is the minor section title
  # all other content within the minor section should be rendered as-is
  
  majorsection.children.each do |e|
    
    if e.name.eql?('h1') then
      # print major section header
      pdf.start_new_page
      if pdf.page_count % 2 == 0 then
        pdf.start_new_page
      end
      puts 'processing "' + e.content + '" on page ' + pdf.page_count.to_s
      pdf.move_down 100
      pdf.font "Open Sans Condensed"
      pdf.text e.content, :size => 32
      pdf.move_down 200
      pdf.start_new_page
    end
    
    if e.name.eql?('div') && e.attr('class').eql?('minor-section') then
      
      if pdf.page_count > 1 then
        pdf.start_new_page
      end
      
      # go through minor section children
      e.children.each do |ee|
        
        if ee.name.eql?('h2') then
          # print minor section header
          puts 'processing "' + ee.content + '"'
          pdf.move_down 50
          pdf.font "Open Sans"
          pdf.text ee.content, :size => 18
          pdf.move_down 100
        end
        
        if ee.name.eql?('h3') then
          # print subsection header
          #puts 'processing "' + ee.content + '"'
          pdf.move_down 20
          pdf.font "PT Serif"
          pdf.text ee.content, :leading => 1, :style => :bold
          pdf.move_down 10
          #pdf.move_down 100
        end
        
        # need to do something about 
        # ul, p
        # skip div.image and a tags
        
        if ee.name.eql?('p') then
          pdf.font "PT Serif"
          pdf.text ee.inner_html, :inline_format => true, :align => :justify, :indent_paragraphs => 18, :leading => 1
        end
        
        if ee.name.eql?('ul') then
          ee.children.each do |li|
            if li.name.eql?('li') then
              pdf.font "PT Serif"
              pdf.text "• " + li.inner_html, :inline_format => true, :align => :left, :leading => 1
            end
          end
        end
        
      end
    end
    
  end
  
end

# add some numbers to the bottom of pages
num_string = "<page>"
num_options_right = { 
  :at => [pdf.bounds.right - 100, 0],
  :width => 100, 
  :align => :right,
  :page_filter => :odd,
  :start_count_at => pagecount_start,
  :color => "666666"
}
pdf.number_pages num_string, num_options_right

num_options_left = { 
  :at => [pdf.bounds.left, 0],
  :width => 100, 
  :align => :left,
  :page_filter => :even,
  :start_count_at => (pagecount_start + 1),
  :color => "666666"
}
pdf.number_pages num_string, num_options_left

# finish by writing the file!
pdf.render_file "book-prawn.pdf"