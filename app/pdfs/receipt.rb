class Receipt < Prawn::Document
  attr_reader :attributes, :id, :company, :custom_font, :logo, :message, :product, :receipt_items

  def initialize(attributes)
    @attributes     = attributes
    @id             = attributes.fetch(:id)
    @company        = attributes.fetch(:company)
    @receipt_items  = attributes.fetch(:receipt_items)
    @custom_font    = attributes.fetch(:font, {})
    @message        = attributes.fetch(:message) { default_message }

    super(margin: 0)

    setup_fonts if custom_font.any?
    generate
  end

  private

    def default_message
      'We\'ve received your payment for <b>'"#{attributes.fetch(:product)}"'</b>. You can keep this receipt for your records.
      Questions? Contact us anytime at <color rgb=\'44bbff\'><link href=\'mailto:'"#{company.fetch(:email)}"'.com?subject=Charge #'"#{id}"'\'>'"#{company.fetch(:email)}"'</link></color>.'
    end

    def setup_fonts
      font_families.update 'PrimaryFont' => custom_font
      font 'PrimaryFont'
      fill_color '384047'
    end

    def generate
      bounding_box [0, 792], width: 612, height: 792 do
        bounding_box [85, 792], width: 442, height: 792 do
          header
          charge_details
          footer
        end
      end
    end

    def header
      move_down 60

      image open(company.fetch(:logo)), height: 32, position: :center

      move_down 25
      text "<color rgb='7b8b8e'>RECEIPT ##{attributes.fetch(:id)}</color>", inline_format: true, align: :center, size: 14

      move_down 10
      horizontal_line 200, 242

      move_down 20
      text message, inline_format: true, size: 11, leading: 4
    end

    def charge_details
      move_down 15

      borders = receipt_items.length - 2

      table(receipt_items, cell_style: { border_color: 'dadfe2', size: 11, inline_format: true }, width: bounds.width) do
        cells.padding = 9
        cells.borders = []
        row(0..borders).borders = [:bottom]
      end
    end

    def footer
      move_down 140
      text "<color rgb='f0f2f7'>Thank you.</color>", inline_format: true, size: 42, style: :bold, character_spacing: (-0.75)
      move_down 25
      text company.fetch(:name), inline_format: true, style: :bold
      move_down 10
      text "<color rgb='7b8b8e'>#{company.fetch(:address)}</color>", inline_format: true, size: 11
    end
end
