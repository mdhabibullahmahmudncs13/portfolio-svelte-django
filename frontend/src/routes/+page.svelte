<script lang="ts">
  import { onMount } from 'svelte';
  import * as api from '$lib/api';
  import type { Hero, Skill, Project, Experience, Certification, Contact, BlogPost, ExtraCurricularActivity } from '$lib/types';

  let hero: Hero | null = null;
  let skills: Skill[] = [];
  let projects: Project[] = [];
  let experience: Experience[] = [];
  let certifications: Certification[] = [];
  let contact: Contact | null = null;
  let blogPosts: BlogPost[] = [];
  let activities: ExtraCurricularActivity[] = [];
  let loading = true;
  let error = '';

  // Contact form state
  let formData = {
    name: '',
    email: '',
    subject: '',
    message: ''
  };
  let formSubmitting = false;
  let formSuccess = false;
  let formError = '';

  // Certification view state
  let showAllAchievements = false;
  let showAllCertificates = false;
  let showAllParticipation = false;
  let showAllCertifications = false;

  onMount(async () => {
    try {
      // Fetch all data in parallel
      const [heroData, skillsData, projectsData, experienceData, certificationsData, contactData, blogData, activitiesData] = await Promise.all([
        api.getHero().catch(() => null),
        api.getSkills().catch(() => []),
        api.getProjects().catch(() => []),
        api.getExperience().catch(() => []),
        api.getCertifications().catch(() => []),
        api.getContact().catch(() => null),
        api.getBlogPosts().catch(() => []),
        api.getActivities().catch(() => [])
      ]);

      hero = heroData;
      skills = skillsData;
      projects = projectsData;
      experience = experienceData;
      certifications = certificationsData;
      contact = contactData;
      blogPosts = blogData;
      activities = activitiesData;
    } catch (err) {
      error = err instanceof Error ? err.message : 'Failed to load data';
      console.error('Error loading data:', err);
    } finally {
      loading = false;
    }
  });

  async function handleContactSubmit(e: Event) {
    e.preventDefault();
    formSubmitting = true;
    formSuccess = false;
    formError = '';

    try {
      const response = await fetch('http://localhost:8000/api/messages/', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData)
      });

      if (!response.ok) {
        throw new Error('Failed to send message');
      }

      formSuccess = true;
      formData = { name: '', email: '', subject: '', message: '' };
      
      setTimeout(() => {
        formSuccess = false;
      }, 5000);
    } catch (err) {
      formError = err instanceof Error ? err.message : 'Failed to send message';
    } finally {
      formSubmitting = false;
    }
  }
</script>

<div class="min-h-screen bg-black">
  {#if loading}
    <div class="flex items-center justify-center min-h-screen">
      <div class="text-xl text-primary-500">Loading...</div>
    </div>
  {:else if error}
    <div class="flex items-center justify-center min-h-screen">
      <div class="text-red-500">Error: {error}</div>
    </div>
  {:else}
    <!-- Navigation -->
    <nav class="fixed top-0 left-0 right-0 z-50 bg-black/90 backdrop-blur-lg border-b border-zinc-800/50">
      <div class="container mx-auto px-6 lg:px-8 py-4 flex items-center justify-between">
        <div class="flex items-center gap-2 group cursor-pointer">
          <svg class="w-8 h-8 text-primary-500 group-hover:scale-110 transition-transform" viewBox="0 0 24 24" fill="currentColor">
            <path d="M18.6 6.62c-1.44 0-2.8.56-3.77 1.53L12 10.66 10.48 12h.01L7.8 14.39c-.64.64-1.49.99-2.4.99-1.87 0-3.39-1.51-3.39-3.38S3.53 8.62 5.4 8.62c.91 0 1.76.35 2.44 1.03l1.13 1 1.51-1.34L9.22 8.2C8.2 7.18 6.84 6.62 5.4 6.62 2.42 6.62 0 9.04 0 12s2.42 5.38 5.4 5.38c1.44 0 2.8-.56 3.77-1.53l2.83-2.5.01.01L13.52 12h-.01l2.69-2.39c.64-.64 1.49-.99 2.4-.99 1.87 0 3.39 1.51 3.39 3.38s-1.52 3.38-3.39 3.38c-.9 0-1.76-.35-2.44-1.03l-1.14-1.01-1.51 1.34 1.27 1.12c1.02 1.01 2.37 1.57 3.82 1.57 2.98 0 5.4-2.41 5.4-5.38s-2.42-5.37-5.4-5.37z"/>
          </svg>
          <span class="text-white font-bold text-xl tracking-tight">PORTFOLIO</span>
        </div>
        <div class="hidden md:flex items-center gap-8 lg:gap-10">
          <a href="#home" class="text-sm font-medium text-gray-400 hover:text-primary-500 transition-colors relative group">
            Home
            <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-primary-500 group-hover:w-full transition-all duration-300"></span>
          </a>
          <a href="#skills" class="text-sm font-medium text-gray-400 hover:text-primary-500 transition-colors relative group">
            Skills
            <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-primary-500 group-hover:w-full transition-all duration-300"></span>
          </a>
          <a href="#projects" class="text-sm font-medium text-gray-400 hover:text-primary-500 transition-colors relative group">
            Projects
            <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-primary-500 group-hover:w-full transition-all duration-300"></span>
          </a>
          <a href="#experience" class="text-sm font-medium text-gray-400 hover:text-primary-500 transition-colors relative group">
            Experience
            <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-primary-500 group-hover:w-full transition-all duration-300"></span>
          </a>
          <a href="#certifications" class="text-sm font-medium text-gray-400 hover:text-primary-500 transition-colors relative group">
            Certifications
            <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-primary-500 group-hover:w-full transition-all duration-300"></span>
          </a>
          <a href="#activities" class="text-sm font-medium text-gray-400 hover:text-primary-500 transition-colors relative group">
            Activities
            <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-primary-500 group-hover:w-full transition-all duration-300"></span>
          </a>
          <a href="#contact" class="px-4 py-2 bg-primary-500 text-black text-sm font-semibold rounded-lg hover:bg-primary-400 transition-all hover:scale-105">
            Contact
          </a>
        </div>
        <!-- Mobile Menu Button -->
        <button class="md:hidden text-gray-400 hover:text-primary-500">
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/>
          </svg>
        </button>
      </div>
    </nav>

    <!-- Hero Section -->
    {#if hero}
      <section id="home" class="min-h-screen flex items-center justify-center pt-20 pb-16">
        <div class="container mx-auto px-4 relative z-10">
          <div class="w-full">
            <div class="flex flex-col-reverse md:flex-row items-center justify-between gap-12">
              <!-- Left Content -->
              <div class="flex-1">
                <!-- Status Badge -->
                <div class="mb-6">
                  <span class="inline-flex items-center gap-2 px-4 py-3 bg-zinc-950 border border-zinc-900 rounded-full text-sm text-gray-400">
                    <span class="w-2 h-2 bg-primary-500 rounded-full animate-pulse"></span>
                    Available for opportunities
                  </span>
                </div>

                <!-- Name -->
                <h1 class="text-6xl md:text-7xl lg:text-8xl font-bold mb-6 text-white">
                  {hero.name}
                </h1>

                <!-- Tagline -->
                <p class="text-2xl md:text-3xl text-primary-500 mb-6 font-medium">
                  {hero.tagline}
                </p>

                <!-- Description -->
                <p class="text-lg text-gray-400 mb-10 max-w-2xl leading-relaxed">
                  {hero.description}
                </p>

                <!-- CTA Buttons -->
                <div class="flex flex-col sm:flex-row gap-4 items-start mb-12">
                  <a href="#projects" class="group inline-flex items-center justify-center gap-2 px-8 py-4 bg-primary-500 text-black text-base font-semibold rounded-lg hover:bg-primary-400 transition-all hover:scale-105 hover:shadow-lg hover:shadow-primary-500/50">
                    <span>View Projects</span>
                    <svg class="w-5 h-5 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"/>
                    </svg>
                  </a>
                  {#if hero.resume_url}
                    <a href={hero.resume_url} target="_blank" rel="noopener" class="group inline-flex items-center justify-center gap-2 px-8 py-4 border-2 border-zinc-800 text-gray-300 text-base font-semibold rounded-lg hover:bg-zinc-900 hover:border-primary-500 transition-all hover:scale-105">
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                      </svg>
                      <span>Download Resume</span>
                    </a>
                  {/if}
                </div>

                <!-- Social Links -->
                <div class="flex space-x-6">
                  {#if hero.github_url}
                    <a href={hero.github_url} target="_blank" rel="noopener" class="text-gray-400 hover:text-primary-500 transition-colors text-2xl">
                      <svg class="w-8 h-8" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"/>
                      </svg>
                    </a>
                  {/if}
                  {#if hero.linkedin_url}
                    <a href={hero.linkedin_url} target="_blank" rel="noopener" class="text-gray-400 hover:text-primary-500 transition-colors text-2xl">
                      <svg class="w-8 h-8" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"/>
                      </svg>
                    </a>
                  {/if}
                  {#if hero.twitter_url}
                    <a href={hero.twitter_url} target="_blank" rel="noopener" class="text-gray-400 hover:text-primary-500 transition-colors text-2xl">
                      <svg class="w-8 h-8" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/>
                      </svg>
                    </a>
                  {/if}
                </div>
              </div>

              <!-- Right - Profile Media (Image or Video) -->
              <div class="flex-shrink-0">
                {#if hero.media_type === 'video' && hero.video_url}
                  <div class="relative">
                    <div class="absolute -bottom-4 -right-4 w-32 h-32 bg-primary-500/30 rounded-full blur-3xl -z-10"></div>
                    <video 
                      src={hero.video_url}
                      autoplay
                      loop
                      muted
                      playsinline
                      class="w-[28rem] h-[18.67rem] md:w-[36rem] md:h-96 lg:w-[42rem] lg:h-[28rem] rounded-xl border-4 border-zinc-900 object-cover shadow-2xl shadow-primary-500/20 hover:shadow-primary-500/40 transition-shadow duration-300 relative z-10"
                    >
                      <track kind="captions" />
                    </video>
                  </div>
                {:else if hero.image_url}
                  <div class="relative">
                    <div class="absolute -bottom-4 -right-4 w-32 h-32 bg-primary-500/30 rounded-full blur-3xl -z-10"></div>
                    <img 
                      src={hero.image_url} 
                      alt={hero.name}
                      class="w-[28rem] h-[18.67rem] md:w-[36rem] md:h-96 lg:w-[42rem] lg:h-[28rem] rounded-xl border-4 border-zinc-900 object-cover shadow-2xl shadow-primary-500/20 hover:shadow-primary-500/40 transition-shadow duration-300 relative z-10"
                    />
                  </div>
                {/if}
              </div>
            </div>
          </div>
        </div>
      </section>
    {/if}

    <!-- Skills Section -->
    {#if skills.length > 0}
      <section id="skills" class="py-16 md:py-24 bg-black">
        <div class="container mx-auto px-4 max-w-6xl">
          <h2 class="section-title text-center mb-12">Skills</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {#each skills as skill}
              <div class="card">
                <h3 class="text-xl font-semibold mb-2 text-white">{skill.name}</h3>
                <p class="text-gray-400 mb-3">{skill.category}</p>
                <div class="w-full bg-zinc-900 rounded-full h-2.5">
                  <div class="bg-primary-500 h-2.5 rounded-full transition-all duration-500" style="width: {skill.proficiency}%"></div>
                </div>
                <p class="text-sm text-gray-500 mt-2">{skill.proficiency}%</p>
              </div>
            {/each}
          </div>
        </div>
      </section>
    {/if}

    <!-- Projects Section -->
    {#if projects.length > 0}
      <section id="projects" class="py-16 md:py-24 bg-zinc-950">
        <div class="container mx-auto px-4 max-w-6xl">
          <h2 class="section-title text-center mb-12">Projects</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {#each projects as project}
              <div class="card group">
                {#if project.featured}
                  <span class="inline-block bg-primary-500 text-black text-xs px-2 py-1 rounded mb-2 font-semibold">Featured</span>
                {/if}
                <h3 class="text-xl font-semibold mb-2 text-white group-hover:text-primary-400 transition-colors">{project.title}</h3>
                <p class="text-gray-400 mb-4">{project.description}</p>
                <div class="flex flex-wrap gap-2 mb-4">
                  {#each project.technologies as tech}
                    <span class="bg-zinc-900 text-primary-400 text-xs px-2 py-1 rounded border border-zinc-800">{tech}</span>
                  {/each}
                </div>
                <div class="flex gap-4">
                  {#if project.demo_url}
                    <a href={project.demo_url} target="_blank" rel="noopener" class="text-primary-500 hover:text-primary-400 transition-colors">Demo →</a>
                  {/if}
                  {#if project.github_url}
                    <a href={project.github_url} target="_blank" rel="noopener" class="text-primary-500 hover:text-primary-400 transition-colors">GitHub →</a>
                  {/if}
                </div>
              </div>
            {/each}
          </div>
        </div>
      </section>
    {/if}

    <!-- Experience Section -->
    {#if experience.length > 0}
      <section id="experience" class="py-16 md:py-24 bg-black">
        <div class="container mx-auto px-4 max-w-4xl">
          <h2 class="section-title text-center mb-12">Experience</h2>
          <div class="space-y-8">
            {#each experience as exp}
              <div class="border-l-4 border-primary-500 pl-6 py-4 hover:border-primary-400 transition-colors">
                <h3 class="text-2xl font-semibold text-white">{exp.position}</h3>
                <p class="text-lg text-gray-300 mb-2">{exp.company}</p>
                <p class="text-sm text-gray-500 mb-3">
                  {new Date(exp.start_date).toLocaleDateString()} - 
                  {exp.current ? 'Present' : (exp.end_date ? new Date(exp.end_date).toLocaleDateString() : 'N/A')}
                </p>
                <p class="text-gray-400 mb-3">{exp.description}</p>
                <div class="flex flex-wrap gap-2">
                  {#each exp.technologies as tech}
                    <span class="bg-zinc-900 text-primary-400 text-xs px-2 py-1 rounded border border-zinc-800">{tech}</span>
                  {/each}
                </div>
              </div>
            {/each}
          </div>
        </div>
      </section>
    {/if}

    <!-- Certifications Section -->
    {#if certifications.length > 0}
      <section id="certifications" class="py-16 md:py-24 bg-zinc-950">
        <div class="container mx-auto px-4 max-w-6xl">
          <h2 class="section-title text-center mb-12">Accomplishments</h2>
          
          <!-- Category Tabs -->
          <div class="flex flex-wrap justify-center gap-3 mb-12">
            <button 
              on:click={() => { showAllAchievements = false; showAllCertificates = false; showAllParticipation = false; showAllCertifications = false; }}
              class="px-6 py-2.5 rounded-lg font-semibold transition-all {!showAllAchievements && !showAllCertificates && !showAllParticipation ? 'bg-primary-500 text-black' : 'bg-zinc-900 text-gray-400 hover:bg-zinc-800 hover:text-primary-400'}"
            >
              All
            </button>
            {#if certifications.filter(c => c.category === 'achievements').length > 0}
              <button 
                on:click={() => { showAllAchievements = true; showAllCertificates = false; showAllParticipation = false; showAllCertifications = false; }}
                class="px-6 py-2.5 rounded-lg font-semibold transition-all {showAllAchievements ? 'bg-yellow-500 text-black' : 'bg-zinc-900 text-gray-400 hover:bg-zinc-800 hover:text-yellow-400'}"
              >
                Achievements
              </button>
            {/if}
            {#if certifications.filter(c => c.category === 'certificate').length > 0}
              <button 
                on:click={() => { showAllAchievements = false; showAllCertificates = true; showAllParticipation = false; showAllCertifications = false; }}
                class="px-6 py-2.5 rounded-lg font-semibold transition-all {showAllCertificates ? 'bg-blue-500 text-black' : 'bg-zinc-900 text-gray-400 hover:bg-zinc-800 hover:text-blue-400'}"
              >
                Certificates
              </button>
            {/if}
            {#if certifications.filter(c => c.category === 'participation').length > 0}
              <button 
                on:click={() => { showAllAchievements = false; showAllCertificates = false; showAllParticipation = true; showAllCertifications = false; }}
                class="px-6 py-2.5 rounded-lg font-semibold transition-all {showAllParticipation ? 'bg-green-500 text-black' : 'bg-zinc-900 text-gray-400 hover:bg-zinc-800 hover:text-green-400'}"
              >
                Participation
              </button>
            {/if}
          </div>

          <!-- Certifications Grid -->
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {#each certifications.filter(c => {
              if (showAllAchievements) return c.category === 'achievements';
              if (showAllCertificates) return c.category === 'certificate';
              if (showAllParticipation) return c.category === 'participation';
              return true;
            }).slice(0, showAllCertifications ? certifications.length : 3) as cert}
              <div class="card group {cert.category === 'achievements' ? 'border-yellow-500/20 hover:border-yellow-500/50' : cert.category === 'certificate' ? 'border-blue-500/20 hover:border-blue-500/50' : 'border-green-500/20 hover:border-green-500/50'}">
                {#if cert.image_url}
                  <div class="mb-4 rounded-lg overflow-hidden border border-zinc-800 transition-colors {cert.category === 'achievements' ? 'group-hover:border-yellow-500/50' : cert.category === 'certificate' ? 'group-hover:border-blue-500/50' : 'group-hover:border-green-500/50'}">
                    <img 
                      src={cert.image_url} 
                      alt={cert.name}
                      class="w-full h-48 object-cover"
                    />
                  </div>
                {/if}
                {#if cert.category === 'achievements'}
                  <span class="inline-block px-2 py-1 mb-3 rounded text-xs font-semibold uppercase bg-yellow-500/10 text-yellow-500 border border-yellow-500/30">
                    Achievement
                  </span>
                {:else if cert.category === 'certificate'}
                  <span class="inline-block px-2 py-1 mb-3 rounded text-xs font-semibold uppercase bg-blue-500/10 text-blue-500 border border-blue-500/30">
                    Certificate
                  </span>
                {:else if cert.category === 'participation'}
                  <span class="inline-block px-2 py-1 mb-3 rounded text-xs font-semibold uppercase bg-green-500/10 text-green-500 border border-green-500/30">
                    Participation
                  </span>
                {/if}
                <h3 class="text-xl font-semibold mb-2 text-white transition-colors {cert.category === 'achievements' ? 'group-hover:text-yellow-400' : cert.category === 'certificate' ? 'group-hover:text-blue-400' : 'group-hover:text-green-400'}">{cert.name}</h3>
                <p class="text-gray-300 mb-2">{cert.issuer}</p>
                <p class="text-sm text-gray-500 mb-3">
                  Issued: {new Date(cert.issue_date).toLocaleDateString()}
                </p>
                {#if cert.credential_url}
                  <a href={cert.credential_url} target="_blank" rel="noopener" class="text-sm font-medium transition-colors {cert.category === 'achievements' ? 'text-yellow-500 hover:text-yellow-400' : cert.category === 'certificate' ? 'text-blue-500 hover:text-blue-400' : 'text-green-500 hover:text-green-400'}">
                    View Credential →
                  </a>
                {/if}
              </div>
            {/each}
          </div>
          
          <!-- View All Button -->
          {#if certifications.length > 3 && !showAllAchievements && !showAllCertificates && !showAllParticipation}
            <div class="flex justify-center mt-8">
              <button 
                on:click={() => showAllCertifications = !showAllCertifications}
                class="px-8 py-3 bg-primary-500/10 border border-primary-500/30 text-primary-500 rounded-lg hover:bg-primary-500/20 hover:border-primary-500/50 transition-all font-semibold"
              >
                {showAllCertifications ? 'Show Less' : 'View All'}
              </button>
            </div>
          {/if}
        </div>
      </section>
    {/if}

    <!-- Blog Section -->
    {#if blogPosts.length > 0}
      <section class="py-16 md:py-24 bg-zinc-950">
        <div class="container mx-auto px-4 max-w-6xl">
          <h2 class="section-title text-center mb-12">Blog</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {#each blogPosts as post}
              <div class="card group cursor-pointer">
                <h3 class="text-xl font-semibold mb-2 text-white group-hover:text-primary-400 transition-colors">{post.title}</h3>
                <p class="text-gray-400 mb-4">{post.excerpt}</p>
                <div class="flex flex-wrap gap-2 mb-4">
                  {#each post.tags as tag}
                    <span class="bg-zinc-900 text-primary-400 text-xs px-2 py-1 rounded border border-zinc-800">{tag}</span>
                  {/each}
                </div>
                <p class="text-sm text-gray-500">
                  {post.created_at ? new Date(post.created_at).toLocaleDateString() : ''}
                </p>
              </div>
            {/each}
          </div>
        </div>
      </section>
    {/if}

    <!-- Contact Section -->
    {#if contact}
      <section id="contact" class="py-16 md:py-24 bg-zinc-950">
        <div class="container mx-auto px-4 max-w-5xl">
          <h2 class="section-title text-center mb-12">Get In Touch</h2>
          
          <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 lg:gap-12">
            <!-- Contact Information -->
            <div class="space-y-6">
              <div>
                <h3 class="text-2xl font-bold text-white mb-6">Contact Information</h3>
                <p class="text-gray-400 mb-8">Feel free to reach out for collaborations or just a friendly chat.</p>
              </div>

              <div class="space-y-4">
                <div class="flex items-start gap-4 p-4 bg-zinc-900/50 border border-zinc-800 rounded-lg hover:border-primary-500/50 transition-colors">
                  <div class="p-2 bg-primary-500/10 rounded-lg">
                    <svg class="w-6 h-6 text-primary-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                    </svg>
                  </div>
                  <div>
                    <h4 class="text-sm font-semibold text-primary-500 mb-1">Email</h4>
                    <a href="mailto:{contact.email}" class="text-gray-300 hover:text-primary-400 transition-colors">{contact.email}</a>
                  </div>
                </div>

                {#if contact.phone}
                  <div class="flex items-start gap-4 p-4 bg-zinc-900/50 border border-zinc-800 rounded-lg hover:border-primary-500/50 transition-colors">
                    <div class="p-2 bg-primary-500/10 rounded-lg">
                      <svg class="w-6 h-6 text-primary-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/>
                      </svg>
                    </div>
                    <div>
                      <h4 class="text-sm font-semibold text-primary-500 mb-1">Phone</h4>
                      <a href="tel:{contact.phone}" class="text-gray-300 hover:text-primary-400 transition-colors">{contact.phone}</a>
                    </div>
                  </div>
                {/if}

                {#if contact.location}
                  <div class="flex items-start gap-4 p-4 bg-zinc-900/50 border border-zinc-800 rounded-lg hover:border-primary-500/50 transition-colors">
                    <div class="p-2 bg-primary-500/10 rounded-lg">
                      <svg class="w-6 h-6 text-primary-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/>
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/>
                      </svg>
                    </div>
                    <div>
                      <h4 class="text-sm font-semibold text-primary-500 mb-1">Location</h4>
                      <span class="text-gray-300">{contact.location}</span>
                    </div>
                  </div>
                {/if}

                <div class="flex items-start gap-4 p-4 bg-zinc-900/50 border border-zinc-800 rounded-lg hover:border-primary-500/50 transition-colors">
                  <div class="p-2 bg-primary-500/10 rounded-lg">
                    <svg class="w-6 h-6 text-primary-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                  </div>
                  <div>
                    <h4 class="text-sm font-semibold text-primary-500 mb-1">Availability</h4>
                    <span class="text-gray-300">{contact.availability}</span>
                  </div>
                </div>
              </div>
            </div>

            <!-- Contact Form -->
            <div class="card">
              <h3 class="text-2xl font-bold text-white mb-6">Send a Message</h3>
              
              {#if formSuccess}
                <div class="mb-6 p-4 bg-primary-500/10 border border-primary-500/50 rounded-lg">
                  <p class="text-primary-400 font-medium">✓ Message sent successfully! I'll get back to you soon.</p>
                </div>
              {/if}

              {#if formError}
                <div class="mb-6 p-4 bg-red-500/10 border border-red-500/50 rounded-lg">
                  <p class="text-red-400">{formError}</p>
                </div>
              {/if}

              <form on:submit={handleContactSubmit} class="space-y-4">
                <div>
                  <label for="name" class="block text-sm font-medium text-gray-300 mb-2">Name *</label>
                  <input
                    type="text"
                    id="name"
                    bind:value={formData.name}
                    required
                    class="input-field"
                    placeholder="Your name"
                    disabled={formSubmitting}
                  />
                </div>

                <div>
                  <label for="email" class="block text-sm font-medium text-gray-300 mb-2">Email *</label>
                  <input
                    type="email"
                    id="email"
                    bind:value={formData.email}
                    required
                    class="input-field"
                    placeholder="your.email@example.com"
                    disabled={formSubmitting}
                  />
                </div>

                <div>
                  <label for="subject" class="block text-sm font-medium text-gray-300 mb-2">Subject *</label>
                  <input
                    type="text"
                    id="subject"
                    bind:value={formData.subject}
                    required
                    class="input-field"
                    placeholder="What's this about?"
                    disabled={formSubmitting}
                  />
                </div>

                <div>
                  <label for="message" class="block text-sm font-medium text-gray-300 mb-2">Message *</label>
                  <textarea
                    id="message"
                    bind:value={formData.message}
                    required
                    rows="5"
                    class="input-field resize-none"
                    placeholder="Your message here..."
                    disabled={formSubmitting}
                  ></textarea>
                </div>

                <button
                  type="submit"
                  disabled={formSubmitting}
                  class="w-full btn-primary disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
                >
                  {#if formSubmitting}
                    <svg class="animate-spin h-5 w-5" fill="none" viewBox="0 0 24 24">
                      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    Sending...
                  {:else}
                    <span>Send Message</span>
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"/>
                    </svg>
                  {/if}
                </button>
              </form>
            </div>
          </div>
        </div>
      </section>
    {/if}
  {/if}
</div>
