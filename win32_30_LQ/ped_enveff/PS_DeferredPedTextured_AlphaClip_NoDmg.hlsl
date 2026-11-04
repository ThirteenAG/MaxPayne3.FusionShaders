sampler2D BumpSampler : register(s4);
sampler2D DiffuseSampler : register(s0);
sampler2D SnowSampler : register(s6);
sampler2D SpecSampler : register(s5);
sampler3D VolumeSampler : register(s7);
float bumpiness : register(c197);
float4 detailSettings : register(c206);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
row_major float4x4 gViewInverse : register(c12);
float4 globalScalars : register(c35);
float4 matMaterialColorScale : register(c202);
float4 specMapExpMask : register(c201);
float3 specMapIntMask : register(c200);
float specularFactor : register(c199);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float3 texcoord7 : TEXCOORD7;
};

struct PS_OUT
{
	float4 color : COLOR;
	float4 color2 : COLOR2;
	float4 color1 : COLOR1;
	float4 color3 : COLOR3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float3 r4;
	float3 r5;
	r0 = tex2D(SnowSampler, i.texcoord.xy);
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r2.xyz = lerp(r1.xyz, r0.xyz, i.texcoord3.xxx);
	r0.x = r1.w * i.texcoord2.w;
	r0.x = r0.x * globalScalars.x;
	r0.yzw = r2.xyz * matMaterialColorScale.xxx;
	r1 = tex2D(SpecSampler, i.texcoord.xy);
	r2.x = r1.z * 16;
	r2.y = frac(r2.x);
	r2.x = r2.x + -r2.y;
	r2.y = (-r2.y >= 0) ? 0 : 1;
	r2.y = (r1.z >= 0) ? 0 : r2.y;
	r2.x = r2.y + r2.x;
	r2.x = r2.x + 0.5;
	r2.z = r2.x * 0.0625;
	r2.xy = detailSettings.zw * i.texcoord.xy;
	r2 = tex3D(VolumeSampler, r2.xyz);
	r2.xyz = r2.yzx * 2 + -1;
	r2.w = detailSettings.x * i.texcoord2.w;
	r2.z = r2.z * r2.w + 1;
	o.color.xyz = r0.yzw * r2.zzz;
	r3 = tex2D(BumpSampler, i.texcoord.xy);
	r0.y = -r3.w + 1;
	r0.y = -r3.x + r0.y;
	r0.yz = (r0.yy >= 0) ? r3.wy : r3.xy;
	r0.yz = r0.yz * 2 + -1;
	r0.yz = r0.yz * bumpiness.xx;
	r0.w = dot(r0.yz, -r0.yz) + 1;
	r2.w = max(r0.w, 0);
	r0.w = rsqrt(r2.w);
	r0.w = 1 / r0.w;
	r3.xyz = r0.yyy * i.texcoord4.xyz;
	r3.xyz = r0.www * i.texcoord1.xyz + r3.xyz;
	r0.yzw = r0.zzz * i.texcoord5.xyz + r3.xyz;
	r0.yzw = r0.yzw + 1E-05;
	r2.w = dot(r0.yzw, r0.yzw);
	r2.w = rsqrt(r2.w);
	r3.xyz = r0.yzw * r2.www + 1E-05;
	r0.yzw = r0.yzw * r2.www;
	r4 = normalize(r3.xyz);
	r3.xyz = -gViewInverse[3].xyz + i.texcoord7.xyz;
	r3.xyz = r3.xyz + 1E-05;
	r5 = normalize(r3.xyz);
	r2.w = dot(r5.xyz, r4.xyz);
	r3.x = r2.w * 1.5 + 1;
	r2.w = (-r2.w >= 0) ? r3.x : 1;
	r3.x = r2.w * i.texcoord2.y;
	r3.y = dot(r1.xyz, specMapIntMask.xyz);
	r1.x = dot(r1, specMapExpMask);
	r1.x = r1.x * specularFactor.x;
	r3.z = max(1, r1.x);
	r1.xy = r3.zy * matMaterialColorScale.ww;
	r1.y = saturate(r1.y * 5);
	r1.y = r1.y * r3.x;
	r1.z = saturate(r1.x * -0.01 + 1);
	r1.x = r1.x * 0.0051020407;
	r1.x = saturate(r1.x);
	r1.x = rsqrt(r1.x);
	r1.x = 1 / r1.x;
	r1.x = rsqrt(r1.x);
	o.color2.y = 1 / r1.x;
	r1.x = r1.y * r1.z;
	r1.x = (r2.w >= 0) ? r1.x : 0;
	r1.x = r3.y * matMaterialColorScale.w + r1.x;
	o.color2.x = saturate(r2.z * r1.x);
	r1.xyz = r2.yyy * i.texcoord5.xyz;
	r1.xyz = i.texcoord4.xyz * r2.xxx + r1.xyz;
	r1.xyz = r1.xyz * detailSettings.yyy;
	r0.yzw = r1.xyz * i.texcoord2.www + r0.yzw;
	r0.yzw = r0.yzw + 1E-05;
	r1.xyz = normalize(r0.yzw);
	o.color1.xyz = r1.xyz * 0.5 + 0.5;
	r0.y = saturate(gAmbientOcclusionEffect.z);
	r0.y = saturate(r0.y + i.texcoord2.x);
	o.color2.z = r0.y * gAmbientOcclusionEffect.w;
	o.color.w = r0.x;
	o.color1.w = r0.x;
	o.color2.w = r0.x;
	r0.xw = float2(1, 0);
	o.color3 = r0.wwwx * gStencil.x;

	return o;
}
