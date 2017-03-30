require 'spec_helper'

describe Workshop, type: :model do

  describe 'validations' do
    it 'validates and associates with' do
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:short_description)
      is_expected.to validate_presence_of(:notes)
      is_expected.to validate_presence_of(:price)
      is_expected.to validate_presence_of(:slug)
      is_expected.to validate_presence_of(:instructor_id)
      is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0)
      is_expected.to validate_numericality_of(:price).is_less_than_or_equal_to(9999.99)

      is_expected.to have_many :purchases
      is_expected.to have_many :purchasers
      is_expected.to have_many :uploads

      is_expected.to belong_to :instructor
    end
  end

  context 'uniqueness' do
    before do
      stub_video
      create :workshop
    end

    it { is_expected.to validate_uniqueness_of(:slug) }
  end

  describe '#has_attachments?' do
    it 'returns true when the workshop has uploads' do
      workshop = build_workshop_with_attachment

      expect(workshop).to have_attachments
    end

    it 'returns false for workshops with no uploads' do
      workshop = build_workshop

      expect(workshop).not_to have_attachments
    end
  end

  describe '#is_free?' do
    context 'when workshop has price 0' do
      it 'returns true' do
        workshop = build_workshop_with_price(0)

        expect(workshop.is_free?).to be_truthy
      end
    end

    context 'when workshop has price other than 0' do
      it 'returns true' do
        workshop = build_workshop_with_price(9.99)

        expect(workshop.is_free?).to be_falsy
      end
    end
  end

  describe '#watchable_for' do
    context 'when workshop has price 0' do
      it 'returns true' do
        user = build_stubbed(:user)
        workshop = build_workshop_with_price(0)

        expect(workshop.watchable_for(user)).to be_truthy
      end
    end

    context 'when user purchased the workshop' do
      it 'returns true' do
        user = create(:user)
        workshop = build_workshop_with_price(9.99)
        create(:purchase, purchasable_id: workshop.id,
                          purchasable_type: workshop.model_name.name,
                          purchaser: user)

        expect(workshop.watchable_for(user)).to be_truthy
      end
    end

    context 'when workshop does not purchased workshop' do
      it 'returns false' do
        user = build_stubbed(:user)
        workshop = build_workshop_with_price(9.99)

        expect(workshop.watchable_for(user)).to be_falsy
      end
    end
  end

  def build_workshop
    stub_video
    build_stubbed(:workshop)
  end

  def build_workshop_with_price(price)
    stub_video
    build_stubbed(:workshop, price: price)
  end

  def build_workshop_with_attachment
    stub_video
    user = create(:user)
    RequestStore.store[:current_user] = user
    workshop = build_stubbed(:workshop, uploads_attributes:
      [ attributes_for(:upload, :attachment) ]
    )
  end
end
