export interface Hero {
  id?: number;
  name: string;
  tagline: string;
  description: string;
  media_type: 'image' | 'video';
  image_url?: string;
  video_url?: string;
  resume_url?: string;
  github_url?: string;
  linkedin_url?: string;
  twitter_url?: string;
}

export interface Skill {
  id?: number;
  name: string;
  category: string;
  proficiency: number;
  icon?: string;
  order: number;
}

export interface Project {
  id?: number;
  title: string;
  description: string;
  long_description?: string;
  media_type: 'image' | 'video';
  image_url?: string;
  video_url?: string;
  demo_url?: string;
  github_url?: string;
  technologies: string[];
  category: string;
  featured: boolean;
  order: number;
}

export interface Experience {
  id?: number;
  company: string;
  position: string;
  description: string;
  start_date: string;
  end_date?: string;
  current: boolean;
  technologies: string[];
  order: number;
}

export interface Certification {
  id?: number;
  name: string;
  issuer: string;
  cert_type: 'certificate' | 'course' | 'license';
  issue_date: string;
  expiry_date?: string;
  credential_id?: string;
  credential_url?: string;
  image_url?: string;
  order: number;
}

export interface Contact {
  id?: number;
  email: string;
  phone?: string;
  location?: string;
  availability: string;
}

export interface Message {
  id?: number;
  name: string;
  email: string;
  message: string;
  read: boolean;
  created_at?: string;
}

export interface BlogPost {
  id?: number;
  title: string;
  slug: string;
  excerpt: string;
  content: string;
  image_url?: string;
  tags: string[];
  published: boolean;
  created_at?: string;
  updated_at?: string;
}
