-- Create challenges table
CREATE TABLE IF NOT EXISTS public.challenges (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    creator_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    start_date TIMESTAMP WITH TIME ZONE NOT NULL,
    end_date TIMESTAMP WITH TIME ZONE NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'active', 'completed', 'cancelled')),
    image_url TEXT,
    rewards JSONB DEFAULT '{}'::jsonb,
    rules JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create challenge participants table
CREATE TABLE IF NOT EXISTS public.challenge_participants (
    challenge_id UUID NOT NULL REFERENCES public.challenges(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    score INTEGER DEFAULT 0,
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    PRIMARY KEY (challenge_id, user_id)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_challenges_creator_id ON public.challenges(creator_id);
CREATE INDEX IF NOT EXISTS idx_challenges_status ON public.challenges(status);
CREATE INDEX IF NOT EXISTS idx_challenge_participants_user_id ON public.challenge_participants(user_id);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for updated_at
CREATE TRIGGER handle_challenges_updated_at
    BEFORE UPDATE ON public.challenges
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

-- Enable Row Level Security
ALTER TABLE public.challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.challenge_participants ENABLE ROW LEVEL SECURITY;

-- Create policies for challenges table
CREATE POLICY "Anyone can view challenges"
    ON public.challenges
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Authenticated users can create challenges"
    ON public.challenges
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = creator_id);

CREATE POLICY "Creators can update their challenges"
    ON public.challenges
    FOR UPDATE
    TO authenticated
    USING (auth.uid() = creator_id)
    WITH CHECK (auth.uid() = creator_id);

CREATE POLICY "Creators can delete their challenges"
    ON public.challenges
    FOR DELETE
    TO authenticated
    USING (auth.uid() = creator_id);

-- Create policies for challenge_participants table
CREATE POLICY "Anyone can view challenge participants"
    ON public.challenge_participants
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Users can join challenges"
    ON public.challenge_participants
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own participation"
    ON public.challenge_participants
    FOR UPDATE
    TO authenticated
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Create function to check if a challenge is active
CREATE OR REPLACE FUNCTION public.is_challenge_active(challenge_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    challenge_status TEXT;
    challenge_start TIMESTAMP WITH TIME ZONE;
    challenge_end TIMESTAMP WITH TIME ZONE;
BEGIN
    SELECT status, start_date, end_date
    INTO challenge_status, challenge_start, challenge_end
    FROM public.challenges
    WHERE id = challenge_id;

    RETURN challenge_status = 'active' 
        AND challenge_start <= timezone('utc'::text, now())
        AND challenge_end >= timezone('utc'::text, now());
END;
$$ LANGUAGE plpgsql; 