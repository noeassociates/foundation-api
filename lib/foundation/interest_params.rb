module Foundation::InterestParams
  UNIT_IDS = -> { Foundation.unit_class.all.collect(&:id) }

  def interest_params! required: true
    rt = required ? :requires : :optional

    params do
      send rt, :first_name, type: String
      send rt, :last_name,  type: String
      send rt, :unit_ids,   type: Array[Integer],
                            values: UNIT_IDS,
                            desc: 'Must only include ids from units returned by the Unit endpoint.'
      optional :email,      type: String, regexp: EmailRegex::EMAIL_ADDRESS_REGEX,
                            desc: 'Must be a valid, non-blank email address.'
      optional :message,    type: String,
                            desc: 'A personal message to be displayed on the site or emailed to the recipient.'
      optional :data,       type: Hash
    end
  end

end
