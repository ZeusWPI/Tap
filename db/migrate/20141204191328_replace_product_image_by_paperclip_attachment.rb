class ReplaceProductImageByPaperclipAttachment < ActiveRecord::Migration[4.2]
  def change
    remove_column :products, :img_path, :string
    add_attachment :products, :avatar
  end
end
