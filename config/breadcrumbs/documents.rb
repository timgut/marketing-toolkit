# Documents
crumb :documents do
  link "My Stuff", documents_path
  parent :root
end

crumb :new_document do |template|
  link "New Document", new_document_path
  parent :template, template
end

crumb :my_designs do |document|
  link 'My Designs', documents_path
  parent :documents
end

crumb :edit_document do |document|
  link "Edit '#{document.title}'", edit_document_path(document)
  parent :my_designs
end

crumb :share_document do |document, template|
  link "Share '#{document.title}'", share_document_path(document)
  parent :my_designs, document, template
end
