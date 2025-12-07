import { PUBLIC_API_URL } from '$env/static/public';

export const API_BASE = PUBLIC_API_URL || 'http://localhost:8000/api';

// Helper function to get full media URLs
export function getMediaUrl(path: string | null | undefined): string {
  if (!path) return '';
  // If path is already a full URL, return as is
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return path;
  }
  // Remove /api from the base URL and append the media path
  const baseUrl = API_BASE.replace('/api', '').replace(/\/+$/, '');
  // Ensure path starts with /
  const cleanPath = path.startsWith('/') ? path : `/${path}`;
  return `${baseUrl}${cleanPath}`;
}

async function fetchAPI(endpoint: string, options: RequestInit = {}) {
  const token = localStorage.getItem('access_token');
  
  const headers: Record<string, string> = {
    'Content-Type': 'application/json',
    ...((options.headers as Record<string, string>) || {})
  };

  if (token) {
    headers['Authorization'] = `Bearer ${token}`;
  }

  const response = await fetch(`${API_BASE}${endpoint}`, {
    ...options,
    headers
  });

  if (!response.ok) {
    throw new Error(`API error: ${response.statusText}`);
  }

  return response.json();
}

// Auth
export async function login(username: string, password: string) {
  const response = await fetch(`${API_BASE.replace('/api', '')}/api/token/`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ username, password })
  });

  if (!response.ok) {
    throw new Error('Login failed');
  }

  const data = await response.json();
  localStorage.setItem('access_token', data.access);
  localStorage.setItem('refresh_token', data.refresh);
  return data;
}

export function logout() {
  localStorage.removeItem('access_token');
  localStorage.removeItem('refresh_token');
}

export function isAuthenticated() {
  return !!localStorage.getItem('access_token');
}

// Hero
export async function getHero() {
  return fetchAPI('/hero/');
}

export async function updateHero(data: any) {
  return fetchAPI('/hero/1/', {
    method: 'PUT',
    body: JSON.stringify(data)
  });
}

// Skills
export async function getSkills() {
  return fetchAPI('/skills/');
}

export async function createSkill(data: any) {
  return fetchAPI('/skills/', {
    method: 'POST',
    body: JSON.stringify(data)
  });
}

export async function updateSkill(id: number, data: any) {
  return fetchAPI(`/skills/${id}/`, {
    method: 'PUT',
    body: JSON.stringify(data)
  });
}

export async function deleteSkill(id: number) {
  return fetchAPI(`/skills/${id}/`, {
    method: 'DELETE'
  });
}

// Projects
export async function getProjects() {
  return fetchAPI('/projects/');
}

export async function createProject(data: any) {
  return fetchAPI('/projects/', {
    method: 'POST',
    body: JSON.stringify(data)
  });
}

export async function updateProject(id: number, data: any) {
  return fetchAPI(`/projects/${id}/`, {
    method: 'PUT',
    body: JSON.stringify(data)
  });
}

export async function deleteProject(id: number) {
  return fetchAPI(`/projects/${id}/`, {
    method: 'DELETE'
  });
}

// Experience
export async function getExperience() {
  return fetchAPI('/experience/');
}

export async function createExperience(data: any) {
  return fetchAPI('/experience/', {
    method: 'POST',
    body: JSON.stringify(data)
  });
}

export async function updateExperience(id: number, data: any) {
  return fetchAPI(`/experience/${id}/`, {
    method: 'PUT',
    body: JSON.stringify(data)
  });
}

export async function deleteExperience(id: number) {
  return fetchAPI(`/experience/${id}/`, {
    method: 'DELETE'
  });
}

// Certifications
export async function getCertifications() {
  return fetchAPI('/certifications/');
}

export async function createCertification(data: any) {
  return fetchAPI('/certifications/', {
    method: 'POST',
    body: JSON.stringify(data)
  });
}

export async function updateCertification(id: number, data: any) {
  return fetchAPI(`/certifications/${id}/`, {
    method: 'PUT',
    body: JSON.stringify(data)
  });
}

export async function deleteCertification(id: number) {
  return fetchAPI(`/certifications/${id}/`, {
    method: 'DELETE'
  });
}

// Contact
export async function getContact() {
  return fetchAPI('/contact/');
}

export async function updateContact(data: any) {
  return fetchAPI('/contact/1/', {
    method: 'PUT',
    body: JSON.stringify(data)
  });
}

// Messages
export async function getMessages() {
  return fetchAPI('/messages/');
}

export async function createMessage(data: any) {
  return fetchAPI('/messages/', {
    method: 'POST',
    body: JSON.stringify(data)
  });
}

export async function markMessageRead(id: number) {
  return fetchAPI(`/messages/${id}/mark_read/`, {
    method: 'POST'
  });
}

export async function deleteMessage(id: number) {
  return fetchAPI(`/messages/${id}/`, {
    method: 'DELETE'
  });
}

// Blog
export async function getBlogPosts() {
  return fetchAPI('/blog/');
}

export async function getBlogPost(slug: string) {
  return fetchAPI(`/blog/${slug}/`);
}

export async function createBlogPost(data: any) {
  return fetchAPI('/blog/', {
    method: 'POST',
    body: JSON.stringify(data)
  });
}

export async function updateBlogPost(slug: string, data: any) {
  return fetchAPI(`/blog/${slug}/`, {
    method: 'PUT',
    body: JSON.stringify(data)
  });
}

export async function deleteBlogPost(slug: string) {
  return fetchAPI(`/blog/${slug}/`, {
    method: 'DELETE'
  });
}

// Extra Curricular Activities
export async function getActivities() {
  return fetchAPI('/activities/');
}

export async function createActivity(data: any) {
  return fetchAPI('/activities/', {
    method: 'POST',
    body: JSON.stringify(data)
  });
}

export async function updateActivity(id: number, data: any) {
  return fetchAPI(`/activities/${id}/`, {
    method: 'PUT',
    body: JSON.stringify(data)
  });
}

export async function deleteActivity(id: number) {
  return fetchAPI(`/activities/${id}/`, {
    method: 'DELETE'
  });
}
